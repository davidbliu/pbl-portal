class ReminderResponse < ActiveRecord::Base
	def self.email_hash
		h = {}
		ReminderResponse.all.each do |r|
			if not h.keys.include?(r.member_email)
				h[r.member_email] = []
			end
			h[r.member_email] << r
		end
		return h
	end
end
