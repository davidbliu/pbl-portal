class FBParser

	def self.like_sticker_id
		369239263222822
	end
	def self.messaging_events(params)
		return params['entry'][0]['messaging']
	end
	def self.message_type(message_event)
		if self.is_postback?(message_event)
			return 'postback'
		elsif self.is_text?(message_event)
			return 'text'
		elsif self.is_image?(message_event)
			return 'image'
		elsif self.is_like?(message_event)
			return 'like'
		else
			return 'unknown'
		end
	end

	def self.is_postback?(message_event)
		message_event.has_key?("postback")
	end

	def self.is_text?(message_event)
		message_event.has_key?("message") and message_event["message"].has_key?("text")
	end

	def self.is_image?(message_event)
		if message_event.has_key?("message") and message_event["message"].has_key?("attachments") and not message_event["message"].has_key?("sticker_id")
			return true
		else
			return false
		end
	end

	def self.is_like?(message_event)
		if message_event.has_key?("message") and message_event["message"].has_key?("sticker_id") and message_event["message"]["sticker_id"]== self.like_sticker_id
			return true
		else
			return false
		end
	end

	def self.sender_id(message_event)
		if message_event.has_key?("sender") and message_event["sender"].has_key?("id")
			return message_event["sender"]["id"]
		else
			return false
		end
	end

	def self.get_text(message_event)
		return message_event["message"]["text"]
	end
	def self.get_seq(message_event)
		begin
			return message_event["message"]["seq"].to_s
		rescue
			return "-1"
		end
	end

	def self.get_image_url(message_event)
		return message_event["message"]["attachments"][0]["payload"]["url"]
	end
end



text_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927154601, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927154572, "message"=>{"mid"=>"mid.1460927154560:342e00fa2b62630475", "seq"=>8, "text"=>"hi bot"}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927154601, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927154572, "message"=>{"mid"=>"mid.1460927154560:342e00fa2b62630475", "seq"=>8, "text"=>"hi bot"}}]}]}}
image_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927497761, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927497726, "message"=>{"mid"=>"mid.1460927497583:349be21f279045c561", "seq"=>11, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://scontent.xx.fbcdn.net/hphotos-xpl1/v/t34.0-12/13022191_10209212088048439_282983228_n.png?oh=5be8884b70e75af07b0900e46ee1c882&oe=57166DEC"}}]}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927497761, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927497726, "message"=>{"mid"=>"mid.1460927497583:349be21f279045c561", "seq"=>11, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://scontent.xx.fbcdn.net/hphotos-xpl1/v/t34.0-12/13022191_10209212088048439_282983228_n.png?oh=5be8884b70e75af07b0900e46ee1c882&oe=57166DEC"}}]}}]}]}}
sticker_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927478363, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927478320, "message"=>{"mid"=>"mid.1460927478306:04f9aa2f5e629e5688", "seq"=>10, "sticker_id"=>209575352566300, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xtf1/t39.1997-6/p100x100/851577_209575355899633_2072364476_n.png"}}]}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927478363, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927478320, "message"=>{"mid"=>"mid.1460927478306:04f9aa2f5e629e5688", "seq"=>10, "sticker_id"=>209575352566300, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xtf1/t39.1997-6/p100x100/851577_209575355899633_2072364476_n.png"}}]}}]}]}}
like_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927519247, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927519219, "message"=>{"mid"=>"mid.1460927519209:2d667cda3db4ff8910", "seq"=>12, "sticker_id"=>369239263222822, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xfa1/t39.1997-6/851557_369239266556155_759568595_n.png"}}]}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927519247, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927519219, "message"=>{"mid"=>"mid.1460927519209:2d667cda3db4ff8910", "seq"=>12, "sticker_id"=>369239263222822, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xfa1/t39.1997-6/851557_369239266556155_759568595_n.png"}}]}}]}]}}
postback_params = {"object"=>"page", "entry"=>[{"id"=>1709967682591538, "time"=>1460929057849, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1709967682591538}, "timestamp"=>1460929057849, "postback"=>{"payload"=>"help"}}]}], "controller"=>"pablo", "action"=>"pablo", "pablo"=>{"object"=>"page", "entry"=>[{"id"=>1709967682591538, "time"=>1460929057849, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1709967682591538}, "timestamp"=>1460929057849, "postback"=>{"payload"=>"help"}}]}]}}

events = FBParser.messaging_events(postback_params)
events.each do |e|
	puts FBParser.message_type(e)
	puts FBParser.get_seq(e)
	puts FBParser.sender_id(e)
end


