class Reminder < ActiveRecord::Base

	def self.test
		Reminder.create(
			member_email:'davidbliu@gmail.com',
			author: 'alice.sun94@gmail.com',
			title: 'make a cookie for me',
			body:'what is the time that you need?',
			link: 'http://pbl.link/parse'
		)
	end

	def self.get_recipients(str, members)
		str = str.downcase.strip
		committees = Member.committees.map{|x| x.downcase}
		if committees.include?(str)
			return members.select{|x| x.committee == str.upcase}.map{|x| x.email}
		elsif str == 'all'
			return Member.current_members.where.not(committee:'GM').map{|x| x.email}
		else
			
			m = members.select{|x| x.name.downcase == str or x.email == str}
			if m.length > 0
				return m.map{|x| x.email}
			else
				return str
			end
		end
	end

end
