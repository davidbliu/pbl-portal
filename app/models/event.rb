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
	def self.migrate
		session = GoogleDrive.saved_session("drive_config.json")
		key = '1GJnRDWjY_1Q1IVHQ5M7AHANiq7s2UumAW9eVY4qqMM0'
		ws = session.spreadsheet_by_key(key).worksheets[0]
		rows = ws.rows
		index = 0
		rows.each do |row|
			if index == 0
				index += 1
			else
				e = Event.where(
					name: row[0]
				).first_or_create
				e.time = Time.strptime(row[1], '%m/%d/%Y')
				e.points = row[2].to_i
				e.semester = 'Spring 2016'
				e.save
			end
		end
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

	def self.scoreboard(members)
		score_hash = self.score_hash(members)
		score_list = members.map{|x| x.email}
		score_list = score_list.sort_by{|x| - score_hash[x]}.map{|x| [x, score_hash[x]]}
	end

	def self.cm_scoreboard
		cms = Member.get_group('cms')
		return self.scoreboard(cms).uniq
	end

	def self.officer_scoreboard
		officers = Member.get_group('officers')
		return self.scoreboard(officers).uniq
	end

	def self.committee_attendance_rates
		committees = Member.committees.select{|x| x != 'GM'}
		current_members = Member.current_members.where.not(committee:'GM')
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

	def self.get_score(email)
		attended = Event.all.select{|x| x.attended.include?(email)}
		pts = attended.map{|x| x.points}
		return pts.sum
	end

	def self.clean?
		Event.all.each do |event|
			a = event.get_attended
			b = event.get_unattended
			a.each do |email|
				if b.include?(email)
					return false
				end
			end
			b.each do |email|
				if a.include?(email)
					return false
				end
			end
		end
		return true
	end

	def self.clean
		Event.all.each do |event|
			event.attended = event.get_attended.uniq
			event.unattended = event.get_unattended.uniq
			event.save
		end
	end


end
