class TablingSlot < ActiveRecord::Base
	serialize :member_emails

	def time_string
	  return TablingSlot.get_day(self.time) + ' at '+ TablingSlot.get_hour(self.time)
	end

	def get_day
		return TablingSlot.get_day(self.time)
	end
	def get_hour
		return TablingSlot.get_hour(self.time)
	end

	# ex: TablingSlot.get_time_string(0) # => "Monday at 12:00am"
	def self.get_time_string(time)
		return TablingSlot.get_day(time) +  ' at '+TablingSlot.get_hour(time)
	end

	# converts time (0..168) to a string
	# ex: TablingSlot.get_day(0) # => "Monday"
	def self.get_day(time)
	  day = time / 24
	  day_strings = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
	  day_string = day_strings[day]
	  return day_string
	end

	# ex: TablingSlot.get_hour(0) # => 12:00am
	def self.get_hour(time)
	  hour = time % 24
	  h = hour % 12
	  if h==0
	    h=12
	  end
	  half = hour >= 12 ? 'pm': 'am'
	  hour_string =  h.to_s+':00'+half
	  return hour_string
	end

	def self.get_slot_by_email(email)
		TablingSlot.all.select{|x| x.member_emails.include?(email)}.first
	end	
end

