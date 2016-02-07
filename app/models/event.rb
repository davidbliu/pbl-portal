require "google/api_client"
require "google_drive"
class Event < ActiveRecord::Base

	def self.migrate
		session = GoogleDrive.saved_session("drive_config.json")
		key = '18yg8ZZG9lijZPVU4rM9RZajd6eGVKgMMPe09WINVoxs'
		ws = session.spreadsheet_by_key(key).worksheets[0]
		rows = ws.rows
		index = 0
		rows.each do |row|
			if index == 0
				index += 1
			else
				puts 'this row was '
				puts row
			end
		end
	end
end
