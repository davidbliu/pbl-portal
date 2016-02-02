class Post < ActiveRecord::Base
	serialize :tags

	def to_json
		return {
			title: self.title,
			content: self.content,
			author: self.author,
			view_permissions: self.view_permissions,
			edit_permissions: self.edit_permissions,
			timestamp: self.timestamp,
			tags: self.tags,
			last_editor: self.last_editor,
			created_at: self.created_at,
			id: self.id
		}.to_json
	end

	def self.permissions_list
		['Only Me', 'Only Execs', 'Only Officers', 'Only PBL', 'Anyone']
	end

	def self.can_access(position)
		if position == 'chair'
			return ['Only Officers', 'Only PBL', 'Anyone']
		elsif position == 'exec'
			return ['Only Execs', 'Only Officers', 'Only PBL', 'Anyone']
		elsif position == 'cm'
			return ['Only PBL', 'Anyone']
		else
			return ['Anyone']
		end
	end

	def self.can_view(member)
		semesters = Semester.past_semesters
		viewable = []
		semesters.each do |semester|
			pos = Position.where(member_email: member.email, semester: semester).first
			pos = pos ? pos.position : 'gm'
			posts = Post.where(semester: semester)
				.where('author = ? OR last_editor = ? OR view_permissions in (?)',
				 member.email,
				 member.email,
				 self.can_access(pos)
			)
			viewable = viewable + posts.map{|x| x.id}
		end
		return viewable
	end

	def can_edit(member)
		# if is admin, return true
		if Post.is_admin(member)
			return true
		end
		if member.email == self.author or member.email == self.last_editor
			return true
		end
		if self.semester == nil 
			return true
		else
			pos = Position.where(semester:self.semester, member_email: member.email).first
			if pos
				if Post.can_access(pos).include?(self.edit_permissions)
					return true
				end
			end
		end
		return false
	end


	def get_view_permissions
		self.view_permissions ? self.view_permissions : 'Anyone'
	end

	def get_edit_permissions
		self.edit_permissions ? self.edit_permissions : 'Anyone'
	end


	def self.tags
		['Pin', 'Announcements', 'Other', 'Reminders', 'Events', 'Email','Tech']
	end

	def self.is_admin(member)
		admin_emails = ['davidbliu@gmail.com', 'akwan726@gmail.com', 'nathalie.nguyen@berkeley.edu']
		if member and admin_emails.include?(member.email)
			return true
		end
		return false
	end


end


