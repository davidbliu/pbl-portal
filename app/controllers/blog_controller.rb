class BlogController < ApplicationController
	def index
		@tag = params[:tag]
		if @tag
			@posts = Post.order('created_at DESC')
				.where('id in (?)', Post.can_view(current_member))
				.to_a
				.select{|x| x.tags and x.tags.include?(@tag)}
		else
			@posts = Post.order('created_at DESC')
				.where('id in (?)', Post.can_view(current_member))
				.to_a
				
		end
		@posts = @posts.paginate(:page => params[:page], :per_page => 15)
	end

	def edit
		@post = Post.new
		@editing = false
		@permissions_list = Post.permissions_list
		@tags = Post.tags
		if params[:id]
			@post = Post.find(params[:id])
			@editing = true
			if not @post.can_edit(current_member)
				render :template => 'members/unauthorized'
			end
		end
		@post = @post.to_json
	end

	# view individual post
	def post
		@post = Post.find(params[:id])
	end

	def save
		if params[:id] and params[:id] != ''
			post = Post.find(params[:id])
		else
			post = Post.new
			post.author = current_member.email
			post.semester = Semester.current_semester
		end
		post.title = params[:title]
		post.tags = params[:tags]
		post.edit_permissions = params[:edit_permissions]
		post.view_permissions = params[:view_permissions]
		post.content = params[:content]
		post.last_editor = current_member.email
		post.save!
		render nothing: true, status: 200
	end

	def destroy
		Post.find(params[:id]).destroy!
		render nothing: true, status: 200
	end

	def email
		@post = Post.find(params[:id])
	end
end
