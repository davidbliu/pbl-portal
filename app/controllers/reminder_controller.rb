class ReminderController < ApplicationController
	skip_before_filter :verify_authenticity_token
	def index
		@key = session[:key] ? session[:key] : 'portal'
		@url = session[:url] ? session[:url] : '/'
		@reminders = Reminder.order('created_at DESC')
			.where(member_email: myEmail)
		render :layout => false
	end

	def redirect
		r = Reminder.find(params[:id])
		r.destroy
		reminders = Reminder.where(member_email:myEmail).length
		if reminders == 0
			Rails.cache.write(myEmail+':reminders', nil)
		end
		redirect_to r.link
	end

	def delete
		Reminder.find(params[:id]).destroy
		reminders = Reminder.where(member_email:myEmail).length
		if reminders == 0
			Rails.cache.write(myEmail+':reminders', nil)
		end
		render nothing: true, status:200
	end

	def new

	end

	def destroy_all
		Reminder.destroy_all
		Rails.cache.clear
		redirect_to '/reminders/admin'
	end

	def destroy_id
		Reminder.where(reminder_id: params[:id]).destroy_all
		render nothing: true, status: 200
	end


	def admin
		@reminders = Reminder.all.to_a
	end

	def create
		emails = params[:emails]
		emails.each do |email|
			email = email.strip
			Reminder.create(
				member_email: email,
				author: myEmail,
				title: params[:title],
				body: params[:body],
				link: params[:link],
				reminder_id: params[:id]
			)
			Rails.cache.write(email+':reminders', true)
		end
		render nothing: true, status: 200
	end

end
