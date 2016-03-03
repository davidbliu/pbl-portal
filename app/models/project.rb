class Project < ActiveRecord::Base
	serialize :images
	serialize :links
	serialize :emails
	serialize :members
	serialize :xfields

	def get_links
		links ? links : []
	end

	def get_images
		images ? images : []
	end

	def get_data
		xfields ? xfields : {}

	end

	def get_embed
		embed ? embed : nil
	end

	def embed?
		embed != nil and embed != ''
	end

	def youtube_embed
	end

	def get_members
		members ? members : []
	end


	def self.fields
		['name', 'description', 'links', 'semester', 'images', 'emails']
	end

	def self.import_worksheet(key, index)
		session = GoogleDrive.saved_session("drive_config.json")
		ws = session.spreadsheet_by_key(key).worksheets[index]
		rows = ws.rows
		index = 0
		fields = []
		rows.each do |row|
			if index == 0
				fields = row
				index += 1
			else
				name = row[0]
				description = row[1]
				links = row[2].split(',').map{|x| x.strip}
				semester = row[3].downcase
				images  = row[4].split(',').map{|x| x.strip}
				mnames = row[5].split(',').map{|x| x.strip}
				emails = Member.where('name in (?)', mnames).pluck(:email).uniq
				embed = row[6]
				# fill out their projects to
				Profile.where('email in (?)', emails).each do |profile|
					projects = profile.get_projects
					if not projects.include?(name)
						projects << name
						profile.projects = projects
						profile.save
					end
				end
				pj = Project.where(name: name).first_or_create
				pj.name = name
				pj.members = mnames
				pj.emails = emails.uniq
				pj.semester = semester
				pj.description = description
				pj.links = links
				pj.images = images
				pj.embed = embed ? embed : nil
				pj.save
			end
		end
	end
	def self.import
		key = '1Ag7mg2882QQGb2FNAf4Shy2zjWqsLjM7T8qyVzkDD4U'
		[1,2].each do |index|
			self.import_worksheet(key, index)
		end

	end

end
