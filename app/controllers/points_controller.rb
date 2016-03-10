
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
		@scores = @scoreboard.map{|x| x[1]}.select{|x| x != 0}
		
		@ranges = []
		num_bins = 10
		@bins = Array.new(num_bins, 0)
		@max = @scores.max
		@min = @scores.min
		@median = @scores.median
		step = @max/num_bins.to_f
		(0..num_bins).each do |i|
			@ranges << (step*i).to_i
		end
		@scores.each do |score|
			bin_i = (score/@max.to_f * num_bins).to_i
			@bins[bin_i] = @bins[bin_i] ? @bins[bin_i] + 1 : 1
		end
		sum = @scores.sum
		@mean = @scores.mean
		@std = @scores.standard_deviation
		
		@myScore = Event.get_score(myEmail)
		@email_hash = Member.email_hash
		# @zeros = @scoreboard.select{|x| x[1] == 0}.map{|x| x[0]}
		# @zeros = @zeros.select{|x| @email_hash[x].committee != 'AC' and @email_hash[x].committee != 'GM'}
		# @zeros = @zeros.sort_by{|x| @email_hash[x].committee}


		Thread.new{
			GoLinkClick.create(
				key: '/points/distribution',
				golink_id: 'distribution_id',
				member_email: myEmail
			)
			ActiveRecord::Base.connection.close
		}
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
			att << myEmail
			unatt.delete(myEmail)
		else
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
    def median
      s = self.sort
      return s[(self.length/2).ceil]
    end

end 