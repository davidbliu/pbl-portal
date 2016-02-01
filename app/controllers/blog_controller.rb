class BlogController < ApplicationController
	def index
		@posts = Post.order('created_at DESC').paginate(:page => params[:page], :per_page => 15)
	end
end
