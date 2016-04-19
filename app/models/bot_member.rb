class BotMember < ActiveRecord::Base

	def self.get_member_from_id(sender_id)
		bm = BotMember.where(sender_id: sender_id)
		if bm.length != 0
			name = bm.first.name
		else
			name = self.get_name_from_fb(sender_id)
			BotMember.where(sender_id: sender_id).destroy_all
			BotMember.create(sender_id: sender_id, name: name)
		end
		puts 'Name: '+name
		return Member.where(name: name).first
	end

	def self.get_name_from_fb(sender_id)
		token = 'EAAHxkxJBZAosBAL6FZBRIM2wJ990bGqDNqDARI4lnHbzQT5yvsNEogZCivDMhMCquWwvgIZCkcZBvQChEbiP7DGL2jlQeSUOHgbddYK3fwcRDIDWdXeLegZA6NNUUZAWJRcRj0iZCO6AsbwjUZARjfFXeENyeMOlfkTbqYpICgMuT1gZDZD'
		fb_url = 'https://graph.facebook.com/v2.6/'+sender_id.to_s+'?fields=first_name,last_name,profile_pic&access_token='+token.to_s
		r = RestClient.get fb_url, :content_type => :json, :accept => :json
		r = JSON.parse(r)
		name = r["first_name"]+' '+r["last_name"]
		return name
	end

	def self.get_partner_id(sender_id)
		kevin = 1176216605723368
		david = 951139591673712
		if sender_id == david
			return kevin
		elsif sender_id == kevin
			return david
		end
	end

	def self.generate_names
		names = ['r2d2', 'obi', 'vader', 'lucy', 'shan', 'mulan', 'oz', 'ash', 'misty', 'brock', 'belle', 'aurora', 'mickey', 'gaston', 'pluto', 'pooh', 'dopey', 'ariel', 'harry', 'ron', 'nemo', 'dory', 'meg', 'simba', 'sully', 'mike', 'merida', 'jasmine', 'hans', 'sven', 'elsa', 'olaf', 'anna', 'hops', 'lilo', 'stitch', 'joy', 'anger', 'disgust', 'peter', 'hook', 'nala', 'pluto', 'woody', 'buzz']
		names = names.shuffle
		bots = BotMember.all.to_a
		bots.each_with_index do |bm, index|
			bm.alias = names[index % names.length]
			bm.save
		end
	end

end
