class Notification < ActiveRecord::Base
	serialize :channels

	def self.channels
		self.channel_map.keys
	end

	def self.channel_map
		return {}
	end
end
