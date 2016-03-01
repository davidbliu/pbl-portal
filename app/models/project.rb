class Project < ActiveRecord::Base
	serialize :images
	serialize :links
	serialize :emails

	def get_links
		links ? links : []
	end

	def get_images
		images ? images : []
	end

	def self.import
		session = GoogleDrive.saved_session("drive_config.json")
		key = '1Ag7mg2882QQGb2FNAf4Shy2zjWqsLjM7T8qyVzkDD4U'
		ws = session.spreadsheet_by_key(key).worksheets[1]
		rows = ws.rows
		index = 0
		rows.each do |row|
			if index == 0
				index += 1
			else
				name = row[0]
				description = row[1]
				links = row[2].split(',').map{|x| x.strip}
				semester = row[3]
				images  = row[4].split(',').map{|x| x.strip}
				mnames = row[5].split(',').map{|x| x.strip}
				emails = Member.where('name in (?)', mnames).pluck(:email).uniq

				pj = Project.where(name: name).first_or_create
				pj.name = name
				pj.emails = emails.uniq
				pj.semester = semester
				pj.description = description
				pj.links = links
				pj.images = images
				pj.save
			end
		end
	end

end
