class BotMember < ActiveRecord::Base
	before_save :generate_alias

	@@aliases = ['R2D2', 'Obi', 'Vader', 'Lucy', 'Shan', 'Mulan', 'Oz', 'Ash', 'Misty', 'Brock', 'Belle', 'Aurora', 'Mickey', 'Gaston', 'Pluto', 'Pooh', 'Dopey', 'Ariel', 'Harry', 'Ron', 'Nemo', 'Dory', 'Meg', 'Simba', 'Sully', 'Mike', 'Merida', 'Jasmine', 'Hans', 'Sven', 'Elsa', 'Olaf', 'Anna', 'Hops', 'Lilo', 'Stitch', 'Joy', 'Anger', 'Disgust', 'Peter', 'Hook', 'Nala', 'Pluto', 'Woody', 'Buzz', 'Bird', 'Dim', 'Dot', 'Flik', 'Francis', 'Gypsy', 'Heimlich', 'Hopper', 'Manny', 'Molt', 'Rosie', 'Slim', 'Alice', 'Bill', 'Dinah', 'Dodo', 'Doorknob', 'Dormouse', 'Mad hatter', 'Chicha', 'Kronk', 'Kuzco', 'Pacha', 'Yzma', 'Edna', 'Bob', 'Elastigirl', 'Violet', 'Syndrome', 'Scar', 'Bashful', 'Doc', 'Dopey', 'Grumpy', 'Happy']
	@@adjectives = ["admiring","adoring","agitated","amazing","angry","awesome","backstabbing","berserk","big","boring","clever","cocky","compassionate","condescending","cranky","desperate","determined","distracted","dreamy","drunk","ecstatic","elated","elegant","evil","fervent","focused","furious","gigantic","gloomy","goofy","grave","happy","high","hopeful","hungry","insane","jolly","jovial","kickass","lonely","loving","mad","modest","naughty","nauseous","nostalgic",
		"pedantic","pensive","prickly","reverent","romantic","sad","serene","sharp","sick","silly","sleepy","small","stoic","stupefied","suspicious","tender","thirsty","tiny","trusting"]
	@@nouns = ['Corn', 'Peas', 'Pepper', 'Acorn', 'Bokchoy', 'Taro', 'Potato', 'Spinach', 'Melon', 'Apple', 'Grape', 'Lemon', 'Pear', 'Pineapple', 'Tomato', 'Lychee', 'Lime', 'Turkey', 'Cow', 'Turtle', 'Lamb', 'Boba', 'Salad', 'Tree', 'Grass', 'Pizza', 'Fries', 'Burger', 'Nose', 'Eye', 'Ear', 'Hair', 'Balls', 'Fork', 'Spoon', 'Door', 'Straw', 'Hat', 'Shirt', 'Rose', 'Tulip', 'Rice', 'Noodle']
	def get_alias
		self.alias ? self.alias : ''
	end

	def random_alias
		used = BotMember.select(:alias).map(&:alias)
		rand = nil
		while rand.nil? or used.include?(rand)
			adj = @@adjectives.sample.capitalize
			noun = @@nouns.sample
			rand = "#{adj} #{noun}"
		end
		return rand
	end
	def group_ids
		BotMember.where(group_id: self.group_id).where.not(sender_id: self.sender_id).pluck(:sender_id)
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
		begin
			r = RestClient.get fb_url, :content_type => :json, :accept => :json
			r = JSON.parse(r)
			name = r["first_name"]+' '+r["last_name"]
			return name
		rescue => e
			puts e.response
		end
	end

	def group_aliases
		BotMember.where(group_id: self.group_id).where.not(alias: self.alias).pluck(:alias)
	end

	def generate_alias
		if not self.alias
			self.alias = self.random_alias
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

	def send_topic
		ids = BotMember.where(group_id: self.group_id).pluck(:sender_id)
		if self.group_id.nil? or ids.length < 2
			Pablo.send(self.sender_id, {:text => "Looks like you dont have a partner yet"})
		else
			topic_body = Topic.random_topic
			aliases = BotMember.where(group_id: self.group_id).pluck(:alias).join(' and ')
			ids.each do |id|
				Pablo.send(id, {:text => "Hey #{aliases}, #{topic_body}"})
			end
		end
	end

	def advertise_topic
		ids = BotMember.where(group_id: self.group_id).pluck(:sender_id)
		if self.group_id.nil? or ids.length < 2
		else
			topic_body = Topic.random_topic
			aliases = BotMember.where(group_id: self.group_id).pluck(:alias).join(' and ')
			ids.each do |id|
				Pablo.send(id, {:text => "Hey #{aliases}, heres something that might spice up your conversation: If any of you types \"topic\" to me, I will find an interesting topic for two to chat about ;)"})
			end
		end
	end

	def skip
		if self.group_id.nil?
			return
		end
		curr_group_id = self.group_id
		BotMember.where(group_id: self.group_id).each do |bm|
			bm.last_group_id = curr_group_id
			bm.group_id = nil
			bm.save!
		end
		BotMember.fix_unpaired
	end

	def self.fix_unpaired
		unpaired = BotMember.where(group_id: nil)
		done = []
		pairings = []
		unpaired.each do |bm1|
			unpaired.each do |bm2|
				if bm1.id != bm2.id and
					(bm1.last_group_id != bm2.last_group_id or bm1.last_group_id.nil? or bm2.last_group_id.nil?) and
					done.exclude?(bm1.id) and
					done.exclude?(bm2.id)
					
					pairings << [bm1, bm2]
					done << bm1.id
					done << bm2.id
				end
			end
		end
		pairings.each do |p|
			puts p.map{|x| x.alias}.to_s
			self.pair(p[0], p[1])
		end
	end

	def self.print_pairings
		pairings = []
		BotMember.where.not(group_id: nil).select(:group_id).map(&:group_id).uniq.each do |group_id|
			pairings << BotMember.where(group_id: group_id).pluck(:alias)
		end
		pairings.each do |p|
			puts p.to_s
		end
	end

	def self.pair(bm1, bm2)
		group_id = BotMember.all.pluck(:group_id).map{|x| x.to_i}.max.to_i + 1
		bm1.group_id = group_id
		bm2.group_id = group_id
		bm1.save!
		bm2.save!
		bm1.alert_group
		bm2.alert_group
	end
	def pairing_info
		names = BotMember.where(group_id: self.group_id).where.not(group_id: nil).where.not(id: self.id).pluck(:alias)
		if names.length == 0
			txt = "I'm still looking for a good pair for you..."
		else
			txt = "You are paired with "+names.join(', ')
		end
		return txt
	end
	def alert_group
		
		Pablo.send(self.sender_id, {:text => self.pairing_info})
	end

	def duplicate
		d = self.dup
		d.sender_id = self.sender_id+'1'
		d.save!
	end

	def self.announce_namechange
		BotMember.all.each do |bm|
			Pablo.send(bm.sender_id, {:text => "Hey #{bm.name}, to make aliases less gender specific, I've changed your alias to \"#{bm.alias}\""})
			if not bm.group_id.nil?
				Pablo.send(bm.sender_id, {:text => "Your partner is still the same, but he/she is now to be known as \"#{bm.group_aliases.join(',')}\"! Have fun a great rest of your Wednesday :)"})
			end
		end
	end

	def self.announce_4gen

		BotMember.all.each do |bm|
			s1 = {:text => "Happy Thursday #{bm.name} :) :) I'm thuper excited for Fourth Gen, are you? Heres some info about the candidates"}
			s2 = {:text => "You can bring up this menu by asking me \"candidates\" if you need it later!"}
			Pablo.send(bm.sender_id, s1)
			Pablo.send(bm.sender_id, DefaultMessage.platforms)
			Pablo.send(bm.sender_id, s2)
		end
	end


end
