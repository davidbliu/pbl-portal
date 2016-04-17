class BotMember < ActiveRecord::Base

	def self.get_member_from_id(sender_id)
		puts "GETTING NAME"
		bm = BotMember.where(sender_id: sender_id)
		if bm.length != 0
			name = bm.first.name
		else
			name = self.get_name_from_fb(sender_id)
			BotMember.where(sender_id: sender_id).destroy_all
			BotMember.create(sender_id: sender_id, name: name)
		end
		puts 'name that i look for member is '+name
		return Member.where(name: name).first
	end

	def self.get_name_from_fb(sender_id)
    puts 'getting name'
    token = 'EAAHxkxJBZAosBAL6FZBRIM2wJ990bGqDNqDARI4lnHbzQT5yvsNEogZCivDMhMCquWwvgIZCkcZBvQChEbiP7DGL2jlQeSUOHgbddYK3fwcRDIDWdXeLegZA6NNUUZAWJRcRj0iZCO6AsbwjUZARjfFXeENyeMOlfkTbqYpICgMuT1gZDZD'
    fb_url = 'https://graph.facebook.com/v2.6/'+sender_id.to_s+'?fields=first_name,last_name,profile_pic&access_token='+token.to_s
    r = RestClient.get fb_url, :content_type => :json, :accept => :json
    r = JSON.parse(r)
    name = r["first_name"]+' '+r["last_name"]
    return name
  end
end
