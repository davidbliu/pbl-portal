class PushController < ApplicationController
	def index
		@me = current_member
	end

	def register
		gcm_id  = params[:gcm_id]
		me = Member.find(current_member.id)
		me.gcm_id = gcm_id
		me.save!
		render nothing:true, status:200
	end
end
