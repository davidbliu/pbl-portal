class GroupsController < ApplicationController
	
	def index
		@groups = Group.list(myEmail).includes(:group_members)
		# includes(:group_members).all
	end

	def new
		@warning = flash[:warning]
		@group = Group.new
	end


	def create
		failed = false
		existing = Group.find_by_name(params[:name])
		if existing
			failed = true
		else
			group = Group.create( 
				name: params[:name],
				description: params[:description],
				is_open: params[:group_type] != 'private',
				creator: myEmail)
		end
		# fails if group with same key already exists
		if not failed
			emails = params[:emails].split(',')
			emails << myEmail
			emails = emails.uniq.map{|x| x.strip}
			emails.each do |email|
				GroupMember.where(
					group_id: group.id,
					email: email).first_or_create
			end
			redirect_to '/go'
		else
			flash[:warning] = "Cannot create a group with the name #{params[:name]}"
			redirect_to :back
		end
	end

	# TODO check if this person can actual destroy group
	def destroy
		group = Group.find(params[:id])
		group.destroy
		redirect_to '/groups'
	end

	def edit
		@group = Group.find(params[:id])
		@editing = true
		render :new
	end

	def update
		@group = Group.find(params[:id])
		@group.name = params[:name]
		@group.description = params[:description]
		@group.is_open = params[:group_type] != 'private'
		@group.save!
		# update members too
		GroupMember.where(group_id: @group.id).destroy_all
		emails = params[:emails].split(',')
		emails << myEmail
		emails = emails.uniq.map{|x| x.strip}
		emails.each do |email|
			email = email.strip
			GroupMember.where(
				group_id: @group.id,
				email: email).first_or_create
		end
		redirect_to :back
	end


end
