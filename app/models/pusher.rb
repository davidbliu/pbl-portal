class Pusher
	def self.push
		gcm = GCM.new(ENV["GOOGLE_PUSH_API_KEY"])
		registration_ids = []
		chrome_id ='APA91bHtmb3clH1iMyeYwTpXoZk6bdp4auRliobBCdcK7SBjgdEJq2OQCb9qYYHdSYs-Y_7EAItObuNOc5DXd65gbKP9x38REKITuM3y319N1Q2wmDQgUHXwxOchBeovtjA1Ededpd5-dPGEPpj3Fjx6MKKlbNhg6Q'
		registration_ids << chrome_id
		opt = {
		  type: "basic",
		  title: "Blog",
		  message: "10 reasons you should quit your job",
		  iconUrl: "logo-135.png"
		}

		options = {
			data: {
				options: opt,
				link: 'http://pbl.link/parse',
				id: '12345'
			},
			collapse_key: 'message'
		}
		# options = {data: {id: SecureRandom.hex.to_s, title: title, message: message,timestamp:Time.now.to_s,sender: sender ? sender.name : 'none', type:'links', key:link}, collapse_key: "updated_score"}
		response = gcm.send(registration_ids, options)
		return response
	end
end
