class PushController < ApplicationController
	def index
		@me = current_member
	end

	def register
		@gcm_id  = params[:gcm_id]
		@token = params[:token]
		@me = Member.find(current_member.id)
		if @gcm_id
			@me.gcm_id = @gcm_id
			@me.save!
		end
	end

	def new
	end

	def create
	end
	
end
