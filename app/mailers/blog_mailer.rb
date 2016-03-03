class BlogMailer < ActionMailer::Base

	default from: "berkeleypbl.vpoperations@gmail.com"

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

  	def mail_post(email, post)
  		@post = post
  		@subject = post.title
  		mail(
  			:to=> email, 
  			:subject => @subject,
  			:from => 'PBL Blog <berkeleypbl.vpoperations@gmail.com>'
  		)
  	end
end