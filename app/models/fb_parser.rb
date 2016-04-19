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
	def self.get_postback(message_event)
		return message_event["postback"]["payload"]
	end
	def self.get_seq(message_event)
		begin
			return message_event["message"]["seq"].to_s
		rescue
			return "-1"
		end
	end

	def self.get_message(message_event)
		begin 
			return message_event["message"]
		rescue
			return false
		end
	end

	def self.get_image_url(message_event)
		return message_event["message"]["attachments"][0]["payload"]["url"]
	end

	def self.is_pablo_command(message_event)
		type = self.message_type(message_event)
		case type
		when 'text'
		when 'payload'
		else
		end
	end
end
