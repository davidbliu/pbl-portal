class GroupsController < ApplicationController
	def new
		@warning = flash[:warning]
		@group = Group.new
	end


	def create
		failed = false
		existing = Group.where(key: params[:key]).first
		if existing
			failed = true
		else
			group = Group.create(key: params[:key], creator: myEmail)
		end
		# fails if group with same key already exists
		if not failed
			emails = params[:emails].split(',')
			emails << myEmail
			emails = emails.uniq.map{|x| x.strip}
			emails.each do |email|
				GroupMember.where(
					group: group.key,
					email: email).first_or_create
			end
			# render nothing: true, status: 200
			redirect_to '/go'
		else
			flash[:warning] = 'A group with the same key already exists'
			redirect_to :back
			# render json: 'a group with the same key already exists', status: 500
		end
	end

	def index
		@groups = Group.groups_by_email(myEmail).sort_by{|x| x.created_at}.reverse
	end

	def destroy
		group = Group.find(params[:id])
		if group.creator == myEmail
			group.destroy
		end
		redirect_to '/groups'
	end

	def edit
		@group = Group.find(params[:id])
			end

	def update
		@group = Group.find(params[:id])
		@group.name = params[:name]
		@group.key = params[:key]
		@group.description = params[:description]
		@group.save
		# update members too
		GroupMember.where(group: @group.key).destroy_all
		params[:emails].split(',').each do |email|
			email = email.strip
			GroupMember.where(
				group: @group.key,
				email: email).first_or_create
		end
		redirect_to '/groups'
	end

	def show
		@group = Group.find(params[:id])
		@groups = Group.groups_by_email(myEmail)
		@golinks = @group.golinks
	end

end
