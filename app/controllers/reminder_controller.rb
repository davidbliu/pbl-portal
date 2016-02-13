class ReminderController < ApplicationController
	skip_before_filter :verify_authenticity_token
	

	def destroy_id
		reminder = Reminder.find(params[:id])
		if reminder.author == myEmail or myEmail == 'davidbliu@gmail.com'
			reminder.destroy
			ReminderResponse.where(reminder_id: params[:id]).destroy_all
			Rails.cache.write('reminder_emails', Reminder.reminder_emails)
			redirect_to '/reminders/admin2'
		else
			render :template => 'members/unauthorized'
		end
		
	end


	def admin
		@reminders = Reminder.all.to_a
		@reminder_hash = {}
		@reminders.each do |r|
			if not @reminder_hash.keys.include?(r.reminder_id)
				@reminder_hash[r.reminder_id] = []
			end
			@reminder_hash[r.reminder_id] << r
		end
		@email_hash = Member.email_hash
	end

	def create
		buttons = params[:buttons].select{|x| x != ''}.map{|x| x.strip}
		buttons = buttons.length > 0 ? buttons : nil
		r = Reminder.create(
			author: myEmail,
			title: params[:title],
			body: params[:body],
			link: params[:link],
			buttons: buttons,
			reminder_type: params[:has_input] ? 'input' : nil
		)
		members = Member.current_members
		# resolve str  --> email
		rec = params[:recipients]
		rec.each do |str|
			str = str.strip
			emails = Reminder.get_recipients(str, members)
			emails.each do |email|
				ReminderResponse.create(
					member_email: email,
					reminder_id: r.id
				)
			end
		end

		Rails.cache.write('reminder_emails', Reminder.reminder_emails)

		render nothing: true, status: 200
	end


	def view_reminder
		@reminder = Reminder.find(params[:id])
		@responses = ReminderResponse.where(reminder_id: params[:id])
		@email_hash = Member.email_hash


	end

	def new2
		@member_names = Member.current_members.map{|x| x.name}
	end

	def admin2
		@reminder_emails = Rails.cache.read('reminder_emails')
		@reminders = Reminder.order('created_at DESC').all
	end

	def set_response
		response = ReminderResponse.where(
			reminder_id: params[:id],
			member_email: myEmail).first_or_create!
		response.response = params[:response]
		if params[:text]
			response.other_content = params[:text]
		end
		response.save
		Rails.cache.write('reminder_emails', Reminder.reminder_emails)

		render nothing:true, status:200
	end
	def index
		key = params[:key] ? params[:key] : 'tabling'
		@golink = GoLink.where(key: key).first
		resp_id = ReminderResponse.where(member_email: myEmail).where(response: nil).pluck(:reminder_id)
		@reminders = Reminder.order('created_at DESC').where('id in (?)', resp_id)
		render :layout => false
	end

	def refresh
		Rails.cache.write('reminder_emails', Reminder.reminder_emails)
		redirect_to '/reminders/admin2'
	end

	def refresh_response
		resp = ReminderResponse.find(params[:id])
		resp.response = nil
		resp.other_content = nil
		resp.save
		Rails.cache.write('reminder_emails', Reminder.reminder_emails)
		redirect_to '/reminders/reminder/'+resp.reminder_id.to_s
	end

end
