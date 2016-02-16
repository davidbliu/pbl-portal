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
end
