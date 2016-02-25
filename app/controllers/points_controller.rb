class PointsController < ApplicationController
	def index
		redirect_to '/points/attendance'
	end

	def scoreboard
		@cm_scoreboard = Event.cm_scoreboard.first(10)
		@officer_scoreboard = Event.officer_scoreboard.first(10)	
		@email_hash = Member.email_hash

		@committee_rates = Event.committee_attendance_rates
		@committees = @committee_rates.keys
		@committees = @committees.sort_by{|x| -@committee_rates[x]}
	end

	def attendance
		@events = Event.this_semester
			.where('time < ?', Time.now)
		@attended = @events.select{|x| x.get_attended.include?(myEmail)}
			.map{|x| x.id}
		@unattended = @events.select{|x| x.get_unattended.include?(myEmail)}
			.map{|x| x.id}
		@points = @events.select{|x| @attended.include?(x.id)}.map{|x| x.points}
		@points = @points.sum
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
