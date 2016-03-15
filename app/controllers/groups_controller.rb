class GroupsController < ApplicationController
	def create
		failed = false
		existing = Group.where(key: params[:key]).first
		if existing
			if existing.emails.include?(myEmail)
				group = existing
			else
				failed = true
			end
		else
			group = Group.create(key: params[:key])
		end
		# group = Group.where(key: params[:key]).first_or_create
		if not failed
			params[:emails].split(',').each do |email|
				email = email.strip
				GroupMember.where(group: group.key,
					email: email).first_or_create
			end
			render nothing: true, status: 200
		else
			render json: 'failed to create group, name already exists', status: 500
		end

		
	end
end
