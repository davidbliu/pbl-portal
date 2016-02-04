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

	def to_json
		{
			title: self.title,
			body: 'some post about '+self.title,
			timestamp: self.created_at,
			link: self.link,
			id: self.id
		}
	end


end
