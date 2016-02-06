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
	def self.david_push
		gcm = GCM.new(ENV["GOOGLE_PUSH_API_KEY"])
		registration_ids = []
		chrome_id ='APA91bHtmb3clH1iMyeYwTpXoZk6bdp4auRliobBCdcK7SBjgdEJq2OQCb9qYYHdSYs-Y_7EAItObuNOc5DXd65gbKP9x38REKITuM3y319N1Q2wmDQgUHXwxOchBeovtjA1Ededpd5-dPGEPpj3Fjx6MKKlbNhg6Q'
		registration_ids << chrome_id
		notification = Pusher.basic_notification('qewrwer', 'Blog', 'Wazzup mayn', 'http://www.google.com')
		response = gcm.send(registration_ids, notification)
		return response
	end

	def self.push(id, title, body, link)
		gcm = GCM.new(ENV["GOOGLE_PUSH_API_KEY"])
		registration_ids = []
		registration_ids = Member.where.not(gcm_id: nil).map{|x| x.gcm_id}
		notification = Pusher.basic_notification(id, title, body, link)
		response = gcm.send(registration_ids, notification)
		return response
	end

	def self.push_feed_item(item)	
		gcm = GCM.new(ENV["GOOGLE_PUSH_API_KEY"])
		gcm_ids = Member.where('email in (?)', item.recipients).map{|x| x.gcm_id}.select{|x| x != nil}
		n = Pusher.basic_notification(item.id, item.title, item.body, item.link)
		response = gcm.send(gcm_ids, n)
		return response
	end
end
