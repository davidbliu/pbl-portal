
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

		# save it in clicks
		Thread.new{
			GoLinkClick.create(
				key: '/points/scoreboard',
				golink_id: 'scoreboard_id',
				member_email: myEmail
			)
			ActiveRecord::Base.connection.close
		}
	end

	def distribution
		@cm_scoreboard = Event.cm_scoreboard
		@officer_scoreboard = Event.officer_scoreboard
		@scoreboard = @cm_scoreboard + @officer_scoreboard
		@scoreboard = @scoreboard.sort_by{|x| -x[1]}
		@scores = @scoreboard.map{|x| x[1]}
		@bins = []
		@ranges = []
		num_bins = 15
		step = @scores.max/num_bins.to_f
		min = 0
		(0..num_bins+1).each do |i|

			max = min+step
			@ranges << [min,max]
			s = @scores.select{|x| x >= min and x < max}.length
			@bins << s
			min = max
		end
		sum = @scores.sum
		@mean = @scores.mean
		@std = @scores.standard_deviation
		@myScore = Event.get_score(myEmail)
	end

	def attendance
		@events = Event.this_semester
			.where('time < ?', Time.now)
		@attended = @events.select{|x| x.get_attended.include?(myEmail)}
			.map{|x| x.id}
		@unattended = @events.select{|x| x.get_unattended.include?(myEmail)}
			.map{|x| x.id}
		@points = @events.select{|x| x.get_attended.include?(myEmail)}.map{|x| x.points}
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
module Enumerable

    def sum
      self.inject(0){|accum, i| accum + i }
    end

    def mean
      self.sum/self.length.to_f
    end

    def sample_variance
      m = self.mean
      sum = self.inject(0){|accum, i| accum +(i-m)**2 }
      sum/(self.length - 1).to_f
    end

    def standard_deviation
      return Math.sqrt(self.sample_variance)
    end

end 
