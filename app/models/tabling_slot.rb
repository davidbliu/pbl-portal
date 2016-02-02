class TablingSlot < ActiveRecord::Base

	def self.generate_tabling
		TablingSlot.destroy_all

		slots = []
		slots << (10..10+4).to_a
		slots << (34..34+4).to_a
		slots << (58..58+4).to_a
		slots << (82..82+4).to_a
		slots << (106..106+4).to_a
		slots = slots.flatten()

		slots.each do |slot|
			TablingSlot.create(
				time: slot,
				member_emails:[]
			)
		end

	end
end
