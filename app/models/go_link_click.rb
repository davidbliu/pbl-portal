class GoLinkClick < ActiveRecord::Base

	def time_string
		time = self.created_at + Time.zone_offset("PDT")
		return time.strftime('%Y-%m-%d %H:%M:%S')
	end
end
