class Position < ActiveRecord::Base

	def self.save_positions(semester = 'Fall 2015')
		members = Member.where(latest_semester: semester)
		members.each do |member|
			Position.where(semester: semester, member_email: member.email).first_or_create(
				semester: semester,
				member_email: member.email,
				position: member.position,
				committee: member.committee
			)
		end
	end
end
