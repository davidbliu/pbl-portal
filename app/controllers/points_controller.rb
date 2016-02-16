class PointsController < ApplicationController
	def index
		redirect_to '/points/attendance'
	end

	def attendance
		@events = Event.this_semester
		@attended = @events.select{|x| x.get_attended.include?(myEmail)}
			.map{|x| x.id}
		@unattended = @events.select{|x| x.get_unattended.include?(myEmail)}
			.map{|x| x.id}

	end

	def mark_attendance
		event = Event.find(params[:id])
		attended = params[:attended] == 'true'
		att = event.get_attended
		unatt = event.get_unattended
		if attended
			puts 'TRUE'
			att << myEmail
			unatt.delete(myEmail)
		else
			puts 'FALSE'
			unatt << myEmail
			att.delete(myEmail)
		end
		event.attended = att
		event.unattended = unatt
		event.save!
		render nothing: true, status: 200
	end

end
