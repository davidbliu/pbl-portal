require 'elasticsearch/model'
class Post < ActiveRecord::Base
	serialize :tags

	include Elasticsearch::Model
 	include Elasticsearch::Model::Callbacks
 	Post.__elasticsearch__.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_HOST']


 	def self.channel_to_emails(channel)
 		email_dict = {
 			GMs: 'berkeley-pbl-spring-2016-general-members@googlegroups.com',
			CMs: 'berkeley-pbl-spring-2016-committee-members@googlegroups.com',
			CMs_and_Officers: 'berkeleypblcommittees@lists.berkeley.edu',
			Officers: 'berkeleypblofficers@lists.berkeley.edu',
			Execs: 'berkeleypblexecs@lists.berkeley.edu',
			David: 'davidbliu@gmail.com'
 		}
 		return email_dict[channel]
 	end
 	def send_mail(channel)

 		BlogMailer.mail_post(Post.channel_to_emails(channel), self)
 		# add to feed
 		FeedItem.create(
 			title: self.title,
 			body: 'New post out on the blog!',
 			link: 'http://portal.berkeley-pbl.com/blog/post/'+self.id.to_s)
 	end

	def self.channels
		['CMs_and_Officers', 'Execs', 'Officers', 'CMs', 'GMs', 'David']
	end

	def time_string
		self.created_at.strftime('%m-%d-%Y')
	end

	def self.unpin_all
		Post.all.each do |post|
			if post.tags and post.tags.include?('Pin')
				tags = post.tags
				tags.delete('Pin')
				post.tags = tags
				post.save
			end
		end

	end
	def to_json
		return {
			title: self.title,
			content: self.content,
			author: self.author,
			view_permissions: self.view_permissions,
			edit_permissions: self.edit_permissions,
			timestamp: self.timestamp,
			tags: self.tags,
			last_editor: self.last_editor,
			created_at: self.created_at,
			id: self.id
		}.to_json
	end

	def self.permissions_list
		['Only Me', 'Only Execs', 'Only Officers', 'Only PBL', 'Anyone']
	end

	def self.can_access(position)
		if position == 'chair'
			return ['Only Officers', 'Only PBL', 'Anyone']
		elsif position == 'exec'
			return ['Only Execs', 'Only Officers', 'Only PBL', 'Anyone']
		elsif position == 'cm'
			return ['Only PBL', 'Anyone']
		else
			return ['Anyone']
		end
	end

	def self.can_view(member)
		semesters = Semester.past_semesters
		viewable = []
		viewable = Post.where('author = ? OR last_editor = ? OR semester = ? OR view_permissions = ?',
			member.email,
			member.email,
			nil,
			'Anyone'
		).pluck(:id)
		# semesters.each do |semester|
		positions = Position.where(member_email: member.email)
		positions.each do |position|
			# pos = Position.where(member_email: member.email, semester: semester).first
			pos = position.position
			post_ids = Post.where(semester: position.semester)
				.where('view_permissions in (?)',
				 self.can_access(pos)
			).pluck(:id)
			viewable = viewable + post_ids
		end
		return viewable.uniq
	end

	def self.pinned(member)
		viewable = self.can_view(member)
		return Post.order('created_at DESC')
			.where('id in (?)', viewable)
			.to_a
			.select{|x| x.get_tags.include?('Pin')}
	end

	def get_tags
		self.tags ? self.tags : []
	end
	def can_edit(member)
		# if is admin, return true
		if Post.is_admin(member)
			return true
		end
		if member.email == self.author or member.email == self.last_editor
			return true
		end
		if self.semester == nil 
			return true
		else
			pos = Position.where(semester:self.semester, member_email: member.email).first
			if pos
				if Post.can_access(pos).include?(self.edit_permissions)
					return true
				end
			end
		end
		return false
	end


	def get_view_permissions
		self.view_permissions ? self.view_permissions : 'Anyone'
	end

	def get_edit_permissions
		self.edit_permissions ? self.edit_permissions : 'Anyone'
	end


	def self.tags
		['Pin', 'Announcements', 'Other', 'Reminders', 'Events', 'Email','Tech', 'Newsletter']
	end

	def self.is_admin(member)
		admin_emails = ['davidbliu@gmail.com', 'akwan726@gmail.com', 'nathalie.nguyen@berkeley.edu']
		if member and admin_emails.include?(member.email)
			return true
		end
		return false
	end

	def self.feed_type
		'blog'
	end

	def words
		ActionView::Base.full_sanitizer.sanitize(self.content)
	end

	def add_to_feed(members, body='')
		emails = members.map{|x| x.email}
		item = FeedItem.create(
			recipients: emails,
			item_type: Post.feed_type,
			title: self.title,
			body: self.words,
			link: 'http://'+ENV['HOST']+'/blog/post/'+self.id.to_s,
			timestamp: Time.now
		)
		# push this out to everyone
		resp = Pusher.push_feed_item(item)
	end

	def self.feed_test
		Post.all.sample.add_to_feed([Member.david])
	end


end


