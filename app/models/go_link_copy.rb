class GoLinkCopy < ActiveRecord::Base
	def time_string
		self.created_at.strftime('%m-%d-%Y')
	end

	def restore
		GoLink.create(
			key: self.key,
			url: self.url,
			description: self.description,
			member_email: self.member_email,
			groups: self.groups
		)
		self.destroy
	end

	def self.can_view(email)
		if GoLink.admin_emails.include?(email)
			return GoLinkCopy.all.pluck(:id)
		end
		groups = Group.groups_by_email(email)
		ids = []
		groups.each do |group|
			ids += group.copies.pluck(:id)
		end
		ids += GoLinkCopy.where('groups like ?', "%Anyone%").pluck(:id)
		ids += GoLinkCopy.where(member_email: email).pluck(:id)
		return ids.uniq
	end
end
