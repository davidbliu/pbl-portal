class FeedResponse < ActiveRecord::Base

	def self.read(email)
		resp = FeedResponse.where(member_email: email)
		read = resp.select{|x| x.response_type == 'read'}.map{|x| x.feed_item_id}
		return read
	end
	def self.removed(email)
		resp = FeedResponse.where(member_email: email)
		removed = resp.select{|x| x.response_type == 'removed'}.map{|x| x.feed_item_id}
		return removed
	end
end
