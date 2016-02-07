class FeedItem < ActiveRecord::Base
	serialize :recipients

	def self.read(email)
		read = FeedResponse.read(email)
		items = FeedItem.order('created_at DESC')
			.where('id in (?)', read)
			.map{|x| x.to_json}
		return items
	end

	def self.can_access(email)
		pos = Position.where('member_email = ? AND semester = ?',
			email,
			Semester.current_semester)
		list = Post.can_access(pos)
		if list.include?('Anyone')
			list << 'Everyone'
		end
	end

	def self.full_feed(email)
		FeedItem.order('created_at DESC')
			.where('permissions in (?) OR permissions IS NULL OR member_email = ?',
				self.can_access(email),
				email)
	end

	def get_members
		if self.get_permissions == 'Everyone'
			return Member.current_members
		elsif self.get_permissions == 'Only Me'
			return Member.where(email: self.member_email)
		elsif self.get_permissions == 'Only Execs'
			return Member.execs
		elsif self.get_permissions == 'Only Officers'
			return Member.officers
		else
			return Member.current_members.where(committee: self.permissions)
		end
	end

	def push

		response = Pusher.push(
			self.id,
			self.title,
			self.body,
			self.link,
			self.get_members
		)
		FeedPush.create(
			feed_item_id: self.id,
			response: response
		)
		return response
	end

	def self.permissions_list
		['Everyone', 'Only Me', 'Only Execs', 'Only Officers'] + Member.committees
	end


	def self.feed(email)
		read = FeedResponse.read(email)
		removed = FeedResponse.removed(email)
		exclude = read+removed
		items = self.full_feed(email)
			.select{|x| not exclude.include?(x.id)}
			.map{|x| x.to_json}
		return items
	end

	def get_permissions
		self.permissions ? self.permissions : 'Everyone'
	end

	def get_link
		self.link ? self.link : 'http://pbl.link/feed'
	end

	def to_json
		{
			title: self.title,
			body: self.body,
			timestamp: self.created_at,
			link: self.get_link,
			id: self.id,
			permissions: self.get_permissions
		}
	end


end
