class GoLink < ActiveRecord::Base

	def to_json
		return {
	      key: self.key,
	      url: self.url,
	      description: self.description,
	      member_email:  self.member_email,
	      permissions: self.permissions,
	      title: self.title,
	      num_clicks: self.num_clicks,
	      id: self.id
	    }
	end

	def get_permissions
		(self.permissions and self.permissions != '') ? self.permissions : 'Only Officers'
	end
	
	def can_view(member)
		if member == nil
			return self.get_permissions == 'Anyone'
		elsif self.get_permissions == 'Anyone'
			return true
		elsif self.get_permissions == 'Only PBL'
			return (member and member.email != nil and member.email != '')
		elsif self.get_permissions == 'Only Officers'
			return (member and member.position != nil and (member.position == 'chair' or member.position == 'exec'))
		elsif self.get_permissions == 'Only Execs'
			return (member and member.position != nil and member.position == 'exec')
		elsif self.get_permissions == 'Only My Committee'
			return true
		elsif self.member_email == member.email
			return true
		end
	end

end
