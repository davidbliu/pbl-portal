class BlogMailer < ApplicationMailer

	default from: "berkeleypbl.webdev@gmail.com"

	def send_blog_email(members, post)
		puts 'sending blog emails	'
	    @post = post
	    mail( 
	    	:to => members.join(','),
	    	:subject => '[PBL][BLOG]: ' + @post.title 
	    ).deliver
  	end
end