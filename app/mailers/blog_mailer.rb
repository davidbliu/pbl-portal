class BlogMailer < ApplicationMailer

	def send_blog_email(emails, post)
	    @post = post
	    @title = @post.title + ' [PBL][Blog]'
	    mail( 
	    	:to => emails.join(','),
	    	:subject => @title 
	    ).deliver
  	end
end