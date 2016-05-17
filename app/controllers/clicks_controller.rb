class ClicksController < ApplicationController
	@@clicks_per_page = 1000
	def index
		@clicks = Click.order('created_at desc')
			.where('email IS NULL or email != ?', 'davidbliu@gmail.com')
		# TODO: figure out why need explicit null check or null emails wont show
		if params[:name]
			@clicks = @clicks.where(name: params[:name])
			@filtered = true
		end
		if params[:path]
			@clicks = @clicks.where(path: params[:path])
			@filtered = true
		end
		if params[:email]
			@clicks = @clicks.where(email: params[:email])
			@filtered = true
		end
		@clicks = @clicks.paginate(:page => params[:page], :per_page => @@clicks_per_page)
	end
end
