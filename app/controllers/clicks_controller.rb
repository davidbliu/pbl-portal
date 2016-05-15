class ClicksController < ApplicationController
	def index
		@clicks = Click.order('created_at desc').where.not(email: 'davidbliu@gmail.com')
		if params[:name]
			@clicks = @clicks.where(name: params[:name])
			@filtered = true
		end
		if params[:path]
			@clicks = @clicks.where(path: params[:path])
			@filtered = true
		end

		@clicks = @clicks.first(1000)
			
	end
end
