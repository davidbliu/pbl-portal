class TablingController < ApplicationController
	before_filter :is_member
	
	def slots_available
		@members = Member.current_members
			.where.not(committee:'GM')
			.order(:committee)

		# save it in clicks
		Thread.new{
			GoLinkClick.create(
				key: '/tabling/slots_available',
				golink_id: 'tabling_slots_id',
				member_email: myEmail
			)
			ActiveRecord::Base.connection.close
		}
	end

	def chair_tabling
		@starting_slots = TablingManager.starting_slots
		@slots = TablingManager.default_slots
		@availabilities = TablingManager.slot_availabilities
	end

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

		# save it in clicks
		Thread.new{
			GoLinkClick.create(
				key: '/tabling',
				golink_id: 'tabling_id',
				member_email: myEmail
			)
			ActiveRecord::Base.connection.close
		}
	end

	# post a switch request
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

	# admin can switch two members' tabling slots
	def admin_switch
		m1 = Member.where('lower(name) = ?', params[:name1].downcase).first
		m2 = Member.where('lower(name) = ?', params[:name2].downcase).first
		TablingManager.switch_tabling(m1.email, m2.email)
		render nothing: true, status: 200
	end

	def confirm_switch
		request = TablingSwitchRequest.find(params[:id])
		TablingManager.switch_tabling(request.email1, request.email2)
		request.destroy
		redirect_to '/tabling'
	end

	# generates a new tabling schedule, deleting the old
	def generate
		if TablingManager.tabling_admin.include?(myEmail)
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
