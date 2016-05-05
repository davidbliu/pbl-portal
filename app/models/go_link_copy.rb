class GoLinkCopy < ActiveRecord::Base
	has_many :go_link_copy_groups, dependent: :destroy
	has_many :groups, :through => :go_link_copy_groups
	
	def time_string
		self.created_at.strftime('%m-%d-%Y')
	end

	def self.can_view(email)
		groups = Group.where(is_open:true)
		groups += GroupMember.where(email: email).map{|x| x.group}
		ids = GoLinkCopy.all.includes(:groups).select{|x| x.member_email == email or x.groups.length == 0}.map{|x| x.id} #TODO: speed up
		groups.each do |group|
			ids += group.go_link_copies.pluck(:id)
		end
		return ids.uniq
	end

	def group_string
		self.groups.pluck(:name).join(', ')
	end

	def restore
		gl = GoLink.create(
			key: self.key,
			url: self.url,
			description: self.description,
			member_email: self.member_email
		)
		self.groups.each do |group|
			gl.groups << group
		end
		self.destroy
	end

	# def self.can_view(email)
	# 	if GoLink.admin_emails.include?(email)
	# 		return GoLinkCopy.all.pluck(:id)
	# 	end
	# 	groups = Group.groups_by_email(email)
	# 	ids = []
	# 	groups.each do |group|
	# 		ids += group.copies.pluck(:id)
	# 	end
	# 	ids += GoLinkCopy.where('groups like ?', "%Anyone%").pluck(:id)
	# 	ids += GoLinkCopy.where(member_email: email).pluck(:id)
	# 	return ids.uniq
	# end
end
