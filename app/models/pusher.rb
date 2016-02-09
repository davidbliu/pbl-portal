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

	def self.push(id, title, body, link, members = nil)
		gcm = GCM.new(ENV["GOOGLE_PUSH_API_KEY"])
		if members == nil
			members = Member.all
		end
		registration_ids = members.select{|x| x.gcm_id != nil}.map{|x| x.gcm_id}
		notification = Pusher.basic_notification(id, title, body, link)
		response = gcm.send(registration_ids, notification)
		return response
	end

end
