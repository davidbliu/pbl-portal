class BlogController < ApplicationController

	before_filter :is_signed_in

	def index
		@page = params[:page] ? params[:page] : 1
		@query = params[:q]
		if params[:q].present?
			@posts = Post.email_search(myEmail, params[:q])
		else
			@posts = Post.order('created_at desc').where('id in (?)', Post.can_view(myEmail))
			@posts = @posts.includes(:groups)
		end
		
		if params[:view] == 'list'
			@list = true
			@posts = @posts.paginate(:page => params[:page], :per_page => 50)
		else
			@posts = @posts.paginate(:page => params[:page], :per_page => 30)
		end
		
		@email_hash = Member.email_hash
		@post_id = params[:post_id]
		@comments = PostComment.order('created_at desc').where('post_id in (?)', Post.can_view(myEmail)).first(50)
		# track click
		track_click("Blog", nil)
	end

	def ajax_scroll
		if params[:q].present?
			@posts = Post.email_search(myEmail, params[:q])
		else
			@posts = Post.order('created_at desc').where('id in (?)', Post.can_view(myEmail))
			@posts = @posts.includes(:groups)
		end
		
		if @posts.length == 0
			render nothing: true, status: 404
		elsif params[:view] == 'list'
			@posts = @posts.paginate(:page => params[:page], :per_page => 50)
			render :list, layout: false
		else
			@posts = @posts.paginate(:page => params[:page], :per_page => 30)
			@email_hash = Member.email_hash
			render :grid, layout: false
		end

	end

	def edit
		if params[:id] and Post.can_view(myEmail).exclude?(params[:id].to_i)
			redirect_to '/unauthorized'
		else
			@post = Post.new
			@editing = false
			@groups = Group.groups_by_email(myEmail)
			if params[:id]
				@post = Post.find(params[:id])
				@editing = true
			end
		end
		track_click("BlogEdit", nil)
		
	end

	def comments
		@post = Post.find(params[:id])
		@comments = @post.comments.order('created_at desc')
		render layout: false
	end

	def show
		@post = Post.find(params[:id])
		@comments = PostComment.where(post_id: params[:id]).order('created_at DESC')
		@email_hash = Member.email_hash
		# save it in clicks
		track_click("Post", {:id => @post.id, :title => @post.title})
		render layout: false
	end

	def save
		is_new = false
		if params[:id] and params[:id] != ''
			post = Post.find(params[:id])
		else
			post = Post.new
			post.author = myEmail
			post.semester = Semester.current_semester
			is_new = true
		end
		post.update(post_params)
		# push out post to those who can view
		# if is_new
		# 	post.push(post.push_list, myEmail)
		# end
		if params[:group_ids] and params[:group_ids] != ''
			ids = params[:group_ids].split(',').map{|x| x.to_i}
			groups = Group.where('id in (?)', ids)
			post.groups = groups
		end
		redirect_to '/blog'
	end

	def push_post
		post = Post.find(params[:id])
		post.push(post.push_list, myEmail)
		redirect_to :back
	end

	def destroy
		Post.find(params[:id]).destroy!
		redirect_to '/blog'
	end

	def email
		@post = Post.find(params[:id])
		@channels = Post.channels

	end

	def send_email
		post = Post.find(params[:id])
		puts post.content
		post.send_mail(params[:channel])
		render nothing: true, status: 200
	end

	def post_comment
		c = PostComment.new(
			member_email: myEmail,
			content: params[:comment],
			post_id: params[:id]
		)
		c.save!
		render nothing: true, status: 200
	end

	def delete_comment
		PostComment.find(params[:id]).destroy
		render nothing: true, status: 200
	end

	private
	def post_params
		params.permit(:title, :content)
	end
end
