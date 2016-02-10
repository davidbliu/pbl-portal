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

end
