require 'set'
namespace :tabling do
	task :init => :environment do 
		current_members = Member.current_members

		slots = []
		slots << (10..10+4).to_a
		slots << (34..34+4).to_a
		slots << (58..58+4).to_a
		slots << (82..82+4).to_a
		slots << (106..106+4).to_a
		slots = slots.flatten()

		TablingHist.initialize_histogram(current_members, slots)
		puts 'saved new tabling histogram'

		slots = ParseTablingSlot.all.to_a
		
	    if slots.length > 0
	      fname = "tabling_backup.txt"
	      backupFile = File.open(fname, "w")
	      slots.each do |slot|
	        backupFile.puts slot.time.to_s + ':'+slot.member_emails
	      end
	      backupFile.close
	      puts 'backed up tabling slots to '+fname

	      ParseTablingSlot.destroy_all
	      Rails.cache.write('tabling_schedule', nil)
	      puts 'removed previous tabling slots'
	    end
	end

	task :generate => :environment do 
		TablingManager.generate_tabling
		Rails.cache.write('tabling_schedule', nil)
	end
end


task :cantmake => :environment do
end



task :g_tabling => :environment do
	times = 20..50
	members = Member.current_members
	p 'generating tabling'
	assignments = generate_tabling_assignments(times, members)

	generate_tabling_slots(assignments)
end


task :g_random_commitments => :environment do
	Member.all.each do |member|
		p member.name
		hours = 168.times.map{ Random.rand(2) } 
		p hours
		member.commitments = hours
		member.save
	end
end

#
# tabling generation
#


#
# removes current tabling slots
#
def generate_tabling_slots(assignments)
	p 'destroying all tabling slots'
	TablingSlot.destroy_all
	p 'creating new tabling slots'
	assignments.keys.each do |time|
		ts = TablingSlot.new
		ts.time = time
		ts.member_ids = assignments[time].map {|x| x.id}
		p ts.time
		p ts.member_ids
		ts.save
	end

	p 'there are now ' + TablingSlot.all.length.to_s + ' slots'
end

# input slots: tabling slots that you want to fill
# return assignments hash key: slot, value: array of members}
	def generate_tabling_assignments(times, members)
		"""
		create assignment hash of timeslot (hour) to member list
		"""
		unassigned = Set.new(members)
		assignments = Hash.new
		while unassigned.length() > 0
			mcv = get_MCV(unassigned, times)
			lcv = get_LCV(assignments, mcv, times)
			if not assignments.has_key?(lcv)
				assignments[lcv] = Array.new
			end
			assignments[lcv] << mcv
			unassigned.delete(mcv)
		end
		return assignments
	end

	# return the hardest to work with member (least slots open)
	def get_MCV(unassigned, times)
		mcv = []
		max_clashes = -1
		unassigned.each do |member|
			commitments = member.commitments
			clashes = 0
			for time in times
				if commitments[time] == 1
					clashes += 1
				end
			end
			if clashes > max_clashes
				max_clashes = clashes
				mcv = [member]
			elsif clashes == max_clashes
				mcv << member
			end
		end

		mcv = mcv.sample
		return mcv
	end

	# least constrained value
	# slot with highest capacity after member has been assigned
	def get_LCV(assignments, member, times)
		lcv = []
		min_capacity = 1000000
		times.each do |time|
			capacity = 0
			if assignments.has_key?(time)
				capacity = assignments[time].length
			end
			if capacity < min_capacity
				min_capacity = capacity
				lcv = [time]
			elsif capacity == min_capacity
				lcv << time
			end
		end

		lcv = lcv.sample
		return lcv
	end