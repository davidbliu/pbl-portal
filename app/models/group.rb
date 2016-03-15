class Group < ActiveRecord::Base
	def members
		emails = GroupMember.where(group: self.key).pluck(:email)
		Member.where('email in (?)', emails)
	end

	def add_member(member)
		GroupMember.where(group: self.key)
			.where(email: member.email).first_or_create
	end

	def emails
		GroupMember.where(group:self.key).pluck(:email)
	end

	# create groups for sp 16 and fa 15
	def self.seed
		# fa15 
		Group.where(
			name: 'PBL Fall 2015',
			key: 'pbl-fa15'
		).first_or_create
		Position.where(semester: 'Fall 2015').each do |pos|
			GroupMember.wlhere(group:'pbl-fa15',
				email: pos.member_email).first_or_create
		end

		Group.where(
			name: 'Officers Fall 2015',
			key: 'of-fa15').first_or_create
		Position.where(semester:'Fall 2015').where('position = ? or position = ?', 'chair', 'exec').each do |pos| 
			GroupMember.where(group: 'of-fa15',
				email: pos.member_email).first_or_create
		end

		Group.where(
			name: 'Execs Fall 2015',
			key: 'ex-fa15').first_or_create
		Position.where(semester:'Fall 2015').where(position: 'exec').each do |pos|
			GroupMember.where(group:'ex-fa15', 
				email: pos.member_email).first_or_create
		end

		#sp16

		Group.where(
			name: 'PBL Spring 2016',
			key: 'pbl-sp16'
		).first_or_create
		Position.where(semester: 'Spring 2016').each do |pos|
			GroupMember.where(group:'pbl-sp16',
				email: pos.member_email).first_or_create
		end

		Group.where(
			name: 'Officers Spring 2016',
			key: 'of-fa15').first_or_create
		Position.where(semester:'Spring 2016').where('position = ? or position = ?', 'chair', 'exec').each do |pos| 
			GroupMember.where(group: 'of-sp16',
				email: pos.member_email).first_or_create
		end

		Group.where(
			name: 'Execs Spring 2016',
			key: 'ex-fa15').first_or_create
		Position.where(semester:'Spring 2016').where(position: 'exec').each do |pos|
			GroupMember.where(group:'ex-sp16', 
				email: pos.member_email).first_or_create
		end
	end
end
