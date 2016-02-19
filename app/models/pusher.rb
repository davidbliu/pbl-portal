class Pusher

	def self.basic_notification(id, title, body, link)
		opt = {
		  type: "basic",
		  title: title,
		  message: body,
		  iconUrl: "logo-135.png"
		}
		return {
			data: {
				options: opt,
				link: link,
				id: id
			},
			collapse_key: 'message'
		}
	end

	def self.push(id, title, body, link, members = nil, author = nil)
		gcm = GCM.new(ENV["GOOGLE_PUSH_API_KEY"])
		if members == nil
			members = Member.all
		end
		registration_ids = members.select{|x| x.gcm_id != nil}.map{|x| x.gcm_id}
		notification = Pusher.basic_notification(id, title, body, link)
		response = gcm.send(registration_ids, notification)
		return response
	end

	def self.push_post(members, post, author = nil)
		title = 'Check out this post on the blog'
		body = post.title
		link = 'http://portal.berkeley-pbl.com/blog/post/'+post.id.to_s
		response = self.push(post.id, title, body, link, members)
		Push.create(
			title: title,
			body: body,
			push_id: post.id.to_s,
			push_type: 'blog',
			response: response,
			author: author,
			member_emails: members.map{|x| x.email}.uniq
		)
		return response
	end

end
