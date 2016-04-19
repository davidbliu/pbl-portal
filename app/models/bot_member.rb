class BotMember < ActiveRecord::Base
	before_save :generate_alias

	@@aliases = ['R2D2', 'Obi', 'Vader', 'Lucy', 'Shan', 'Mulan', 'Oz', 'Ash', 'Misty', 'Brock', 'Belle', 'Aurora', 'Mickey', 'Gaston', 'Pluto', 'Pooh', 'Dopey', 'Ariel', 'Harry', 'Ron', 'Nemo', 'Dory', 'Meg', 'Simba', 'Sully', 'Mike', 'Merida', 'Jasmine', 'Hans', 'Sven', 'Elsa', 'Olaf', 'Anna', 'Hops', 'Lilo', 'Stitch', 'Joy', 'Anger', 'Disgust', 'Peter', 'Hook', 'Nala', 'Pluto', 'Woody', 'Buzz', 'Bird', 'Dim', 'Dot', 'Flik', 'Francis', 'Gypsy', 'Heimlich', 'Hopper', 'Manny', 'Molt', 'Rosie', 'Slim', 'Alice', 'Bill', 'Dinah', 'Dodo', 'Doorknob', 'Dormouse', 'Mad hatter', 'Chicha', 'Kronk', 'Kuzco', 'Pacha', 'Yzma', 'Edna', 'Bob', 'Elastigirl', 'Violet', 'Syndrome', 'Scar', 'Bashful', 'Doc', 'Dopey', 'Grumpy', 'Happy']
	# def self.get_member_from_id(sender_id)
	# 	bm = BotMember.where(sender_id: sender_id)
	# 	if bm.length != 0
	# 		bm = bm.first
	# 		bm.last_active = Time.now
	# 		bm.save!
	# 		name = bm.name
	# 	else
	# 		name = self.get_name_from_fb(sender_id)
	# 		BotMember.where(sender_id: sender_id).destroy_all
	# 		BotMember.create!(sender_id: sender_id, name: name)
	# 	end
	# 	puts 'Name: '+name
	# 	return Member.where(name: name).first
	# end

	def group_ids
		BotMember.where(group: self.group).where.not(sender_id: self.sender_id).pluck(:sender_id)
	end

	def self.create_from_id(sender_id)
		bm = BotMember.new(sender_id: sender_id)
		bm.name = get_name_from_fb(sender_id)
		bm.save!
		return bm
	end

	def self.get_name_from_fb(sender_id)
		token = 'EAAHxkxJBZAosBAL6FZBRIM2wJ990bGqDNqDARI4lnHbzQT5yvsNEogZCivDMhMCquWwvgIZCkcZBvQChEbiP7DGL2jlQeSUOHgbddYK3fwcRDIDWdXeLegZA6NNUUZAWJRcRj0iZCO6AsbwjUZARjfFXeENyeMOlfkTbqYpICgMuT1gZDZD'
		fb_url = 'https://graph.facebook.com/v2.6/'+sender_id.to_s+'?fields=first_name,last_name,profile_pic&access_token='+token.to_s
		r = RestClient.get fb_url, :content_type => :json, :accept => :json
		r = JSON.parse(r)
		name = r["first_name"]+' '+r["last_name"]
		return name
	end

	def group_aliases
		BotMember.where(group: self.group).where.not(alias: self.alias).pluck(:alias)
	end

	def generate_alias
		if not self.alias
			used = BotMember.all.pluck(:alias)
			unused = @@aliases.select{|x| not used.include?(x)}
			self.alias = unused.sample
		end
	end

	def self.generate_names
		names = @@aliases
		names = names.shuffle
		bots = BotMember.all.to_a
		bots.each_with_index do |bm, index|
			bm.alias = names[index % names.length]
			bm.save
		end
	end

	def swap_groups(other)
		my_group = self.group
		other_group = other.group
		self.group = other_group
		other.group = my_group
		self.save!
		other.save!
		BotMember.where(group: [my_group, other_group]).each do |bm|
			puts bm.alias
			bm.alert_group
		end
	end

	def skip
		other = BotMember.where.not(sender_id: self.sender_id).sample
		self.swap_groups(other)
	end

	def alert_group
		names = BotMember.where(group: self.group).pluck(:alias).select{|x| x != self.alias}
		txt = "You are paired with "+names.join(', ')
		Pablo.send(self.sender_id, {:text => txt})
	end

	def pair(bot_alias)
		bot_alias = bot_alias.capitalize
		if bot_alias != self.alias
			gp = BotMember.find_by_alias(bot_alias)
			if gp
				gp = gp.group
			else
				return false
			end
			if self.group == gp
				return true
			end
			other = BotMember.where.not(alias: bot_alias).where(group: gp).first
			self.swap_groups(other)
			return true
		else
			return false
		end
	end

	def self.generate_groups
		bms = BotMember.all.to_a
		bms = bms.shuffle
		if bms.length % 2 == 0
			pairings = bms.each_slice(2).to_a
		else
			first = bms[0]
			bms = bms[1..-1]
			pairings = bms.each_slice(2).to_a
			pairings[0] << first
		end
		pairings.each_with_index do |gp, index|
			gp.each do |bm|
				bm.group = index
				bm.save!
			end
		end
	end

	def duplicate
		d = self.dup
		d.sender_id = self.sender_id+'1'
		d.save!
	end


end
