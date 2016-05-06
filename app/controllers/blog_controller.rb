class BlogController < ApplicationController

	before_filter :is_signed_in

	def index
		@posts = Post.includes(:groups).order('created_at desc').where('id in (?)', Post.can_view(myEmail)).paginate(:page => params[:page], :per_page => 30)
		@email_hash = Member.email_hash

		# save it in clicks
		Thread.new{
			GoLinkClick.create(
				key: '/blog',
				golink_id: 'blog_id',
				member_email: myEmail
			)
			ActiveRecord::Base.connection.close
		}

		render :template => 'blog/index2'
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
			render :template => "blog/new_edit"
		end
		
	end

	# view individual post
	def post
		@post = Post.find(params[:id])
		@comments = PostComment.where(post_id: params[:id]).order('created_at DESC')
		@email_hash = Member.email_hash
		# save it in clicks
		Thread.new{
			GoLinkClick.create(
				key: '/blog/post/'+params[:id]+':'+@post.title,
				golink_id: 'post_id',
				member_email: myEmail
			)
			ActiveRecord::Base.connection.close
		}
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
		@notifications = Notification.where(
			notification_type: 'blog',
			object_id: params[:id]
		)

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

	private
	def post_params
		params.permit(:title, :content)
	end
end
