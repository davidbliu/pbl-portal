class TablingManager

	def self.tabling_admin
		['davidbliu@gmail.com', 'harukoayabe@gmail.com', 'alexparkap@berkeley.edu']
	end

	@@starting_slots = (0..4).map{|x| 10+24*x}

	# default times for each week (monday - friday 9-1)
	def self.default_slots
		slots = []
		interval = 3
		(0..4).each do |x|
			start = 10+24*x
			end_time = start + interval
			slots << (start..end_time).to_a
		end
		slots = slots.flatten()
	end

	def self.starting_slots
		@@starting_slots
	end

	def self.slot_availabilities
		cms = Member.cms
		chairs = Member.officers
		availabilities = {}
		self.default_slots.each do |slot|
			a_chairs = chairs.select{|x| x.get_commitments.include?(slot)}
			a_cms = cms.select{|x| x.get_commitments.include?(slot)}
			availabilities[slot] = {
				:chairs => a_chairs,
				:cms => a_cms
			}
		end
		return availabilities
	end


	# generates a new tabling schedule and destroys old one
	def self.gen_tabling
		TablingSlot.destroy_all #TODO: simply flag tabling slot as old
		slots = self.default_slots
		officers = Member.officers.where.not(committee: 'AC')
		cms = Member.cms
		# assign officers first, then cms to ensure load balancing among officers
		officer_assignments = self.assign(officers, slots)
		cm_assignments = self.assign(cms, slots, officer_assignments)
		cm_assignments.keys.each do |slot|
			TablingSlot.create(
				time: slot,
				member_emails: cm_assignments[slot].map{|x| x.email}
			)
		end

	end

	def self.switch_tabling(email1, email2)
		slot1 = TablingSlot.get_slot_by_email(email1)
		slot2 = TablingSlot.get_slot_by_email(email2)
		emails1 = slot1.member_emails
		emails1.delete(email1)
		emails2 = slot2.member_emails
		emails2.delete(email2)
		emails2 << email1
		emails1 << email2
		slot1.member_emails = emails1
		slot2.member_emails = emails2
		slot1.save!
		slot2.save!
	end

	# Return assignment hash populated with members
	# {1 => [m1, m2, m3], 2 => [m1, m2, m3]}
	def self.assign(members, slots, assignments = {})
		slots.each do |slot|
			if not assignments.keys.include?(slot)
				assignments[slot] = []
			end
		end
		while members.length > 0
			mcv = self.get_mcv(members, slots)
			lcv = self.get_lcv(mcv, slots, assignments)
			assignments[lcv] << mcv
			# remove member
			members = members.select{|x| x.email != mcv.email}
		end
		return assignments
	end

	def self.get_mcv(members, slots)
		min_slots = 10000
		mcvs = [members.first]
		members.each do |member|
			available = member.get_commitments & slots
			if min_slots > available.length
				min_slots = available.length
				mcvs = [member]
			elsif min_slots == available.length
				mcvs << member
			end
		end
		return mcvs.sample
	end

	def self.get_lcv(member, slots, assignments)
		min_fill = 100000
		
		valid_slots = member.get_commitments & slots
		if valid_slots.length == 0
			valid_slots = [slots.sample]
		end
		lcvs = [valid_slots.first]
		valid_slots.each do |slot|
			slot_members = assignments[slot]
			slot_size = slot_members.length
			if @@starting_slots.include?(slot)
				slot_size -=1 
			end
			if slot_size < min_fill
				min_fill = slot_members.length
				lcvs = [slot]
			elsif slot_size == min_fill
				lcvs << slot
			end
		end	
		return lcvs.sample
	end
end
