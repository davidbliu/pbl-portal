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
		951139591673712
	end

end
