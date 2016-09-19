require "google/api_client"
require "google_drive"
class Event < ActiveRecord::Base
	serialize :attended
	serialize :unattended

	def self.this_semester
		Event.where(semester: Semester.current_semester)
			.order('time DESC')
	end

	def time_string
		self.time.strftime('%m/%d/%Y')
	end

	def get_attended
		self.attended ? self.attended : []
	end

	def get_unattended
		self.unattended ? self.unattended : []
	end

	def self.score_hash(members)
		h = {}
		members.each do |m|
			h[m.email] = 0
		end
		this_semester_events = Event.this_semester
		this_semester_events.each do |event|
			event.get_attended.uniq.each do |email|
				if not h.keys.include?(email)
					h[email] = 0
				end
				h[email] += event.points
			end
		end
		return h
	end

	# returns sorted list of members and their points
	# 	Event.scoreboard(Member.all) # => [[member1, 10], [member2, 9]...]  
	def self.scoreboard(members)
		score_hash = self.score_hash(members)
		score_list = members.map{|x| x.email}
		score_list = score_list.sort_by{|x| - score_hash[x]}.map{|x| [x, score_hash[x]]}
	end

	def self.cm_scoreboard
		cms = Member.cms
		return self.scoreboard(cms).uniq
	end

	def self.officer_scoreboard
		officers = Member.officers
		return self.scoreboard(officers).uniq
	end

	# return hash whose keys are committee abbreviations and values are attendance rates
	# 	Event.committee_attendance_rates # => {'HT': 0.2, 'PB': 0.5}
	def self.committee_attendance_rates
		committees = Member.committees.select{|x| x != 'GM'}
		current_members = Member.chairs_and_cms
		h = {}
		committees.each do |c|
			h[c] = 0
		end
		score_hash = self.score_hash(current_members)
		current_members.each do |m|
			if committees.include?(m.committee)
				h[m.committee] += score_hash[m.email]
			end
		end
		committees.each do |c|
			committee_size = current_members.select{|x| x.committee == c}.length
			h[c] /= committee_size.to_f
		end
		return h
	end

	# returns score for email
	#   Event.get_score('davidbliu@gmail.com') # => 13
	def self.get_score(email)
		attended = Event.all.select{|x| x.get_attended.include?(email)}
		pts = attended.map{|x| x.points}
		return pts.sum
	end

        def self.pull_events
          session = GoogleDrive.saved_session("drive_config.json")
          key = '1GJnRDWjY_1Q1IVHQ5M7AHANiq7s2UumAW9eVY4qqMM0'
          ws = session.spreadsheet_by_key(key).worksheets[0]
          rows = ws.rows
          index = 0
          seen_event_names = [] # we erase events whose names aren't seen
          rows.each do |row|
            if index == 0
                index += 1
            else
              name = row[0]
              time = Time.strptime(row[1], '%m/%d/%Y')
              points = row[2].to_i
              semester = Semester.current_semester
              event = Event.where(name: name).where(semester: semester).first_or_create!
              event.points = points
              event.time = time
              event.save!
              seen_event_names << name
            end
          end
          # remove events whose names have been changed
          unseen_events = Event.where(semester: Semester.current_semester).where('name not in (?)', seen_event_names).destroy_all
        end



end
