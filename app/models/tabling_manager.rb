class TablingManager
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

	def self.random_init
		slots = self.default_slots

		Member.all.each do |member|
			if member.commitments == nil
				member.commitments = slots.sample(5)
				member.save
			end
		end
	end

	def self.gen_tabling
		TablingSlot.destroy_all
		slots = self.default_slots

		officers = Member.where(latest_semester: Semester.current_semester)
			.where('position = ? OR  position = ?', 'chair', 'exec')
			.to_a
		cms = Member.where(latest_semester: Semester.current_semester)
			.where('position = ? AND committee != ?',
				'cm',
				'GM')
			.to_a
		officer_assignments = self.assign(officers, slots)
		cm_assignments = self.assign(cms, slots, officer_assignments)
		cm_assignments.keys.each do |slot|
			TablingSlot.create(
				time: slot,
				member_emails: cm_assignments[slot].map{|x| x.email}
			)
		end

	end
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
			if slot_members.length < min_fill
				min_fill = slot_members.length
				lcvs = [slot]
			elsif slot_members.length == min_fill
				lcvs << slot
			end
		end	
		return lcvs.sample
	end
end