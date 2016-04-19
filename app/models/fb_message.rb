class FBMessage

	@@like_sticker_id = 369239263222822
	@@command_map = {
		tabling: [/^tabling$/],
		blog: [/^blog$/, /^posts$/, /^blogposts$/],
		events: [/^events$/, /^cal$/, /^c$/, /^calendar$/],
		go: [/^go (.*)$/],
		all: [/^all (.*)$/],
		help: [/^help$/],
		points: [/^points$/],
		more_blog: [/^more blog$/],
		joke: [/^joke$/],
		wiki: [/^wiki (.*)$/],
		skip: [/^skip$/],
		pair: [/^pair (.*)$/],
		group: [/^group$/],
		whoami: [/^whoami$/]
	}
	@@pablo_commands = @@command_map.values.flatten
	@@pablo_map = {}
	@@command_map.keys.each do |k|
		@@command_map[k].each do |v|
			@@pablo_map[v] = k
		end
	end

	def initialize(p)
		@params = p
		@bm = BotMember.find_by_sender_id(self.sender_id)
		if not @bm
			@bm = BotMember.create_from_id(self.sender_id)
		end
		@bm.last_active = Time.now
		@bm.save!
		@member = Member.find_by_name(@bm.name)
	end

	def member
		@member
	end

	def bot
		@bm

	end

	def sender_id
		@params["sender"]["id"]
	end

	def type
		if is_postback?
			return 'postback'
		elsif is_text?
			return 'text'
		elsif is_image?
			return 'image'
		elsif is_like?
			return 'like'
		end
	end

	def msg
		if is_postback?
			return self.postback
		elsif is_text?
			return self.text
		else
			return 'hi'
		end
	end

	def forwarded_message
		case self.type
		when 'text'
			sender_alias = @bm.alias ? @bm.alias : 'Anon'
			return {:text => sender_alias +': '+ self.text}
		when 'image'
			return self.image_msg
		end
		return false
	end

	def is_pablo_command?
		return self.pablo_method
	end

	def pablo_method
		if self.type == 'postback' or self.type == 'text'
			command = self.msg
		else
			if self.type == 'like'
				command = 'help'
			else
				return false
			end
		end
		command = command.strip.downcase
		matches = @@pablo_commands.select{|x| (command =~ x) != nil}
		if matches.length > 0
			return @@pablo_map[matches[0]]
		end
		return false
	end

	def is_postback?
		@params.has_key?("postback")
	end

	def is_text?
		@params.has_key?("message") and @params["message"].has_key?("text")
	end

	def is_image?
		if @params.has_key?("message") and @params["message"].has_key?("attachments") and not @params["message"].has_key?("sticker_id")
			return true
		else
			return false
		end
	end

	def is_like?
		if @params.has_key?("message") and @params["message"].has_key?("sticker_id") and @params["message"]["sticker_id"]== @@like_sticker_id
			return true
		else
			return false
		end
	end

	def text
		@params["message"]["text"]
	end

	def postback
		@params["postback"]["payload"]
	end

	def image_url
		@params["message"]["attachments"][0]["payload"]["url"]
	end

	def image_msg
		{
			attachment: {
				type: 'image',
				payload: {
					url: self.image_url
				}
			}
		}
	end

	def stringify
		puts 'printing out event stuff'
		puts pablo_method
		puts msg
		puts @params
	end


end
