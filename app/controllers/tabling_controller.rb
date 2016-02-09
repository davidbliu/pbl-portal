class TablingController < ApplicationController
	def index
		@me = current_member
		slots = TablingSlot
			.order('time ASC')
			.all.to_a
		@slot_hash = {}
		slots.each do |slot|
			day = slot.get_day
			if not @slot_hash.keys.include?(day)
				@slot_hash[day] = []
			end
			@slot_hash[day] << slot
		end
		@switch_requests = TablingSwitchRequest.where('email1 = ? OR email2 = ?', 
			@me.email,
			@me.email
		)
		@email_hash = Member.email_hash
	end

	# post a switch request request
	def switch
		if not current_member
			render nothing: true, status: 500
		else
			member2 = Member.where('lower(name) = ?', params[:name].downcase)
				.where(latest_semester: Semester.current_semester).first
			if member2 == nil
				render nothing: true, status: 500
			else
				member1 = current_member
				TablingSwitchRequest.where('email1 = ? OR email2 = ? OR email1=? OR email2 = ?',
					member1.email,
					member1.email,
					member2.email,
					member2.email
				).destroy_all
				switch_request = TablingSwitchRequest.where(
					email1: member1.email,
					email2: member2.email
				).first_or_create
				render nothing: true, status: 200
			end
		end
	end
	def confirm_switch
		request = TablingSwitchRequest.find(params[:id])
		TablingManager.switch_tabling(request.email1, request.email2)
		request.destroy
		redirect_to '/tabling'
	end

	def generate
		if current_member.email == 'davidbliu@gmail.com'
			TablingManager.gen_tabling
			redirect_to '/tabling'
		else
			render :template => 'members/unauthorized'
		end
	end

	def schedules
		members = Member.where(latest_semester: Semester.current_semester)
			.where.not(committee:'GM').to_a

		slots = TablingManager.default_slots
		@slots = slots
		@free_hash = {}
		slots.each do |slot|
			free = members.select{|x| x.get_commitments.include?(slot)}.map{|x| x.email}
			@free_hash[slot] = free
		end			
		@members = members
		@email_hash = Member.email_hash

	end
end
