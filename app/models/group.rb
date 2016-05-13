class Group < ActiveRecord::Base

	has_many :group_members, dependent: :destroy
	has_many :go_link_groups, dependent: :destroy
	has_many :go_links, :through => :go_link_groups
	has_many :post_groups, dependent: :destroy
	has_many :posts, :through => :post_groups


	def self.list(email)
		group_ids = GroupMember.where(email: email).pluck(:group_id)
		return Group.where('id in (?) OR creator = ? OR is_open = ?',
			group_ids, 
			email, 
			true)
	end

	def can_edit(email)
		if email == self.creator or GoLink.admin_emails.include?(email)
			return true
		else
			return false
		end
	end

	def self.groups_by_email(email)
		ids = GroupMember.where(email: email).pluck(:group_id)
		ids += Group.where(is_open: true).pluck(:id)
		return Group.order('name asc').where('id in (?)', ids)
  	end
  
  	def get_type
  		if is_open
  			return 'Open'
  		else 
  			return 'Private'
  		end
  	end
end
