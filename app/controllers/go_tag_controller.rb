class GoTagController < ApplicationController
	def create
		if GoTag.where(name: params[:name]).length > 0 or params[:name] == nil or params[:name] == ''
			render json: 'That tag already exists'
		else
			GoTag.create(name: params[:name], 
				creator: myEmail)
			render nothing: true, status: 200
		end
	end

	def all
		render json: GoTag.all.to_json
	end

	def show
		@tag = GoTag.find(params[:id])
		ids = GoLinkTag.where(tag_name: @tag.name).pluck(:golink_id)
		@golinks = GoLink.where('id in (?)', ids)
		@golinks = @golinks.paginate(:page => params[:page], :per_page => 100)

		@groups = Group.groups_by_email(myEmail)
	end
end
