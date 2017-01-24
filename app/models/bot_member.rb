class BotMember < ActiveRecord::Base
	before_save :generate_alias
	has_many :messages
	@@aliases = ['R2D2', 'Obi', 'Vader', 'Lucy', 'Shan', 'Mulan', 'Oz', 'Ash', 'Misty', 'Brock', 'Belle', 'Aurora', 'Mickey', 'Gaston', 'Pluto', 'Pooh', 'Dopey', 'Ariel', 'Harry', 'Ron', 'Nemo', 'Dory', 'Meg', 'Simba', 'Sully', 'Mike', 'Merida', 'Jasmine', 'Hans', 'Sven', 'Elsa', 'Olaf', 'Anna', 'Hops', 'Lilo', 'Stitch', 'Joy', 'Anger', 'Disgust', 'Peter', 'Hook', 'Nala', 'Pluto', 'Woody', 'Buzz', 'Bird', 'Dim', 'Dot', 'Flik', 'Francis', 'Gypsy', 'Heimlich', 'Hopper', 'Manny', 'Molt', 'Rosie', 'Slim', 'Alice', 'Bill', 'Dinah', 'Dodo', 'Doorknob', 'Dormouse', 'Mad hatter', 'Chicha', 'Kronk', 'Kuzco', 'Pacha', 'Yzma', 'Edna', 'Bob', 'Elastigirl', 'Violet', 'Syndrome', 'Scar', 'Bashful', 'Doc', 'Dopey', 'Grumpy', 'Happy']
	@@adjectives = ["admiring","adoring","agitated","amazing","angry","awesome","backstabbing","berserk","big","boring","clever","cocky","compassionate","condescending","cranky","desperate","determined","distracted","dreamy","drunk","ecstatic","elated","elegant","evil","fervent","focused","furious","gigantic","gloomy","goofy","grave","happy","high","hopeful","hungry","insane","jolly","jovial","kickass","lonely","loving","mad","modest","naughty","nauseous","nostalgic",
		"pedantic","pensive","prickly","reverent","romantic","sad","serene","sharp","sick","silly","sleepy","small","stoic","stupefied","suspicious","tender","thirsty","tiny","trusting"]
	@@nouns = ['Corn', 'Peas', 'Pepper', 'Acorn', 'Bokchoy', 'Taro', 'Potato', 'Spinach', 'Melon', 'Apple', 'Grape', 'Lemon', 'Pear', 'Pineapple', 'Tomato', 'Lychee', 'Lime', 'Turkey', 'Cow', 'Turtle', 'Lamb', 'Boba', 'Salad', 'Tree', 'Grass', 'Pizza', 'Fries', 'Burger', 'Nose', 'Eye', 'Ear', 'Hair', 'Balls', 'Fork', 'Spoon', 'Door', 'Straw', 'Hat', 'Shirt', 'Rose', 'Tulip', 'Rice', 'Noodle']
	@@pokemon = ['Bulbasaur', 'Ivysaur', 'Venusaur', 'Charmander', 'Charmeleon', 'Charizard', 'Squirtle', 'Wartortle', 'Blastoise', 'Caterpie', 'Metapod', 'Butterfree', 'Weedle', 'Kakuna', 'Beedrill', 'Pidgey', 'Pidgeotto', 'Pidgeot', 'Rattata', 'Raticate', 'Spearow', 'Fearow', 'Ekans', 'Arbok', 'Pikachu', 'Raichu', 'Sandshrew', 'Sandslash', 'Nidoran', 'Nidorina', 'Nidoqueen', 'Nidorino', 'Nidoking', 'Clefairy', 'Clefable', 'Vulpix', 'Ninetales', 'Jigglypuff', 'Wigglytuff', 'Zubat', 'Golbat', 'Oddish', 'Gloom', 'Vileplume', 'Paras', 'Parasect', 'Venonat', 'Venomoth', 'Diglett', 'Dugtrio', 'Meowth', 'Persian', 'Psyduck', 'Golduck', 'Mankey', 'Primeape', 'Growlithe', 'Arcanine', 'Poliwag', 'Poliwhirl', 'Poliwrath', 'Abra', 'Kadabra', 'Alakazam', 'Machop', 'Machoke', 'Machamp', 'Bellsprout', 'Weepinbell', 'Victreebel', 'Tentacool', 'Tentacruel', 'Geodude', 'Graveler', 'Golem', 'Ponyta', 'Rapidash', 'Slowpoke', 'Slowbro', 'Magnemite', 'Magneton', "Farfetch'd", 'Doduo', 'Dodrio', 'Seel', 'Dewgong', 'Grimer', 'Muk', 'Shellder', 'Cloyster', 'Gastly', 'Haunter', 'Gengar', 'Onix', 'Drowzee', 'Hypno', 'Krabby', 'Kingler', 'Voltorb', 'Electrode', 'Exeggcute', 'Exeggutor', 'Cubone', 'Marowak', 'Hitmonlee', 'Hitmonchan', 'Lickitung', 'Koffing', 'Weezing', 'Rhyhorn', 'Rhydon', 'Chansey', 'Tangela', 'Kangaskhan', 'Horsea', 'Seadra', 'Goldeen', 'Seaking', 'Staryu', 'Starmie', 'Mr. Mime', 'Scyther', 'Jynx', 'Electabuzz', 'Magmar', 'Pinsir', 'Tauros', 'Magikarp', 'Gyarados', 'Lapras', 'Ditto', 'Eevee', 'Vaporeon', 'Jolteon', 'Flareon', 'Porygon', 'Omanyte', 'Omastar', 'Kabuto', 'Kabutops', 'Aerodactyl', 'Snorlax', 'Articuno', 'Zapdos', 'Moltres', 'Dratini', 'Dragonair', 'Dragonite', 'Mewtwo', 'Mew']
	def get_alias
		self.alias ? self.alias : ''
	end

	def random_pokemon
		used = BotMember.select(:alias).map(&:alias)
		rand = nil
		while rand.nil? or used.include?(rand)
			rand = @@pokemon.sample
		end
		return rand
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
		fb_url = 'https://graph.facebook.com/v2.6/'+sender_id.to_s+'?fields=first_name,last_name,profile_pic&access_token='+ENV['FB_ACCESS_TOKEN']
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
                        self.save
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
			self.send_msg({:text => "Looks like you dont have a partner yet"})
		else
			topic_body = Topic.random_topic
			aliases = BotMember.where(group_id: self.group_id).pluck(:alias).join(' and ')
			ids.each do |id|
				self.send_msg({:text => "Hey #{aliases}, #{topic_body}"})
			end
		end
	end

	def skip
		if Pablo.get_active_bot_members.exclude?(self)
			return
		end

		BotMember.where(:group_id => self.group_id).each do |bot|
			bot.last_group_id = bot.group_id
			bot.group_id = nil
			bot.save!
		end

		bot_members = Pablo.get_active_bot_members
		if bot_members.length == 1
			bot_members.each do |bm|
				bm.last_group_id = curr_group_id
				bm.group_id = nil
				bm.save!
			end
		end
		BotMember.fix_unpaired
	end

	def self.fix_unpaired
		unpaired = []
		Pablo.get_active_bot_members.each do |bot|
			if BotMember.where(:group_id => bot.group_id).count == 1
				bot.group_id = nil
				unpaired << bot
			end
		end

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

	def self.get_group_id
		BotMember.all.pluck(:group_id).map{|x| x.to_i}.max.to_i + 1
	end

	def self.pair(bm1, bm2)
		group_id = BotMember.get_group_id
		bm1.group_id = group_id
		bm2.group_id = group_id
		bm1.save!
		bm2.save!
		bm1.alert_group
		bm2.alert_group
	end

	def self.group(names)
		bots = BotMember.where("name in (?)", names)
		group_id = self.get_group_id
		bots.each do |bot|
			bot.group_id = group_id
			bot.save!
		end
		bots.each do |bot|
			bot.alert_group
		end
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
		self.send_msg({:text => self.pairing_info})
	end

	def duplicate
		d = self.dup
		d.sender_id = self.sender_id+'1'
		d.save!
	end

	def self.announce_namechange
		BotMember.all.each do |bm|
			bm.send_msg({:text => "Hey #{bm.name}, to make aliases less gender specific, I've changed your alias to \"#{bm.alias}\""})
			if not bm.group_id.nil?
				bm.send_msg({:text => "Your partner is still the same, but he/she is now to be known as \"#{bm.group_aliases.join(',')}\"! Have fun a great rest of your Wednesday :)"})
			end
		end
	end

	def self.send_supports(name, names, num)
      names = names.split(',')
      aliases = BotMember.where('name in (?)', names).pluck(:alias)
      msg = "#{name}, good luck tonight at elections! #{aliases.join(', ')} and others send their support and #{num} people have checked out your platforms!"
      puts msg
      bm1 = BotMember.find_by_name(name)
      bm1.send_msg({:text => msg})
    end

    def send_pokemon_msg(name)
    	url = Pokemon.pokemap[name]
    	self.send_msg(DefaultMessage.pokemon_message(url))
		self.send_msg({:text => "#{self.name.split(' ')[0]}, Who's that pokemon?!"})
    end

    def send_puppy
    	if self.group_id.nil?
    		self.send_msg({:text => "Right! Heres a puppy"})
			self.send_msg({:text => "You got it! Heres a puppy for both of you"})
		else    		
    		BotMember.where(group_id: self.group_id).each do |bm|
    			bm.send_msg({:text => "#{self.alias} got it! Heres a puppy"})
    			bm.send_msg(DefaultMessage.puppy_msg)
    		end
    	end
    end

	def self.p(name1, name2)
      puts "pairing #{name1} and #{name2}"
      BotMember.pair(BotMember.find_by_name(name1), BotMember.find_by_name(name2))
    end

    def self.n(name)
      bm= BotMember.find_by_name(name)
      BotMember.where(group_id:bm.group_id).each do |bot|
        bot.group_id = nil
        bot.save!
      end
    end

    def self.unpaired
      puts BotMember.where(group_id:nil).pluck(:name).to_s
    end

    def log(msg)
    	if msg != 'unrecognized'
    		self.messages.create!(
    			body: msg,
    			sender: 'self'
    		)
    	end
    end
    def log_pablo(msg)
    	puts 'LOOGGGIGNGGGG PABLO'
    	self.messages.create!(
    		body: msg, 
    		sender: 'pablo'
    		)
    end

    def group
    	if self.group_id != nil and self.group_id > -1
    		return BotMember.where(group_id: self.group_id).where.not(id: self.id)
    	end
    	return []
    end

    def send_msg(msg)
	    body = {:recipient => {:id => self.sender_id}, :message => msg}
	    fb_url = 'https://graph.facebook.com/v2.6/me/messages?access_token='+ENV['FB_ACCESS_TOKEN']
	    begin
	    	RestClient.post fb_url, body.to_json, :content_type => :json, :accept => :json
	    	if msg.keys.include?(:text)
		    	log_pablo(msg[:text])
		    end
	    rescue => e
	    	puts 'problem sending message'
	    	puts e
	    end

    end


end
