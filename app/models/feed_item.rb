class FeedItem < ActiveRecord::Base
	serialize :recipients
	# def self.push_feed(member)
	# 	if not member.gcm_id
	# 		puts 'no gcm id, could not push '+member.email+'\'s feed'
	# 		return
	# 	end
	# 	Pusher.push
	# end

	# def push_item(members)
	# end

	def self.full_feed(email)
		items = FeedItem.order('created_at DESC')
		return items
	end

	def push
		Pusher.push(
			self.id,
			self.title,
			self.body,
			self.link
		)
	end


	def self.feed(email)
		read = FeedResponse.read(email)
		removed = FeedResponse.removed(email)
		exclude = read+removed
		items = FeedItem.order('created_at DESC')
			.select{|x| not exclude.include?(x.id)}
			.map{|x| x.to_json}
		return items
	end
	def to_json
		{
			title: self.title,
			body: self.body,
			timestamp: self.created_at,
			link: self.link,
			id: self.id
		}
	end


end
