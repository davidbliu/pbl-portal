class BlogMailer < ActionMailer::Base

	default from: "berkeleypbl.webdev@gmail.com"

	def send_blog_email(emails, post)
	    puts 'ABOUT TO SEND BLOG EMAAIL, EMAILS ARE'
	    puts emails
	    @post = post
	    @title = @post.title + ' [PBL][Blog]'
	    mail( 
	    	:to => emails.join(','),
	    	:subject => @title 
	    ).deliver
  	end

  	def mail_post(emails, post)
  		@post = post
  		@subject = post.title + '[PBL]'
  		mail(
  			:to=> emails.join(','), 
  			:subject => @subject
  		)
  	end
end