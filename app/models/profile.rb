class Profile < ActiveRecord::Base
	serialize :positions
	serialize :projects
	serialize :jobs
	serialize :extracurriculars
	serialize :state_awards
	serialize :case_comps
	serialize :images
	serialize :nicknames
	serialize :awards
	def get_images
		self.images ? self.images : []
	end
	def get_positions
		self.positions ? self.positions : []
	end
	def get_projects
		self.projects ? self.projects : []
	end
	def get_jobs
		self.jobs ? self.jobs : []
	end

	def get_awards
		awards ? awards : []
	end
	def get_nicknames
		self.nicknames ? self.nicknames : []
	end

	def self.import
		session = GoogleDrive.saved_session("drive_config.json")
		key = '1Ag7mg2882QQGb2FNAf4Shy2zjWqsLjM7T8qyVzkDD4U'
		ws = session.spreadsheet_by_key(key).worksheets[0]
		rows = ws.rows
		index = 0
		rows.each do |row|
			if index == 0
				fields = row
				index += 1
			else
				name = row[0]
				nicknames = row[1]
				grad = row[3]
				positions = row[4]
				projects = row[5]
				awards = row[6]
				sblc = row[7]	
				images = row[8]
				jobs = row[9]
				hometown = row[10]
				webpage = row[11]
				major = row[14]
				m = Member.where(name: name).first
				profile = Profile.where(email: m.email).first_or_create!
				profile.grad = grad
				profile.nicknames = nicknames.split(',').map{|x| x.strip}
				profile.positions = positions.split(',').map{|x| x.strip.downcase}
				# profile.projects = projects.split(',').map{|x| x.strip}
				profile.awards = awards.split(',').map{|x| x.strip}
				profile.state_awards = sblc.split(',').map{|x| x.strip}
				profile.images = images.split(',').map{|x| x.strip}
				profile.jobs = jobs.split(',').map{|x| x.strip}
				profile.hometown = hometown
				profile.major = major
				profile.save
			end
		end
	end


end
