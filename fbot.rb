require './app/models/fb_parser.rb'
require './app/models/fb_message.rb'
require './app/models/pablo.rb'


text_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927154601, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927154572, "message"=>{"mid"=>"mid.1460927154560:342e00fa2b62630475", "seq"=>8, "text"=>"hi bot"}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927154601, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927154572, "message"=>{"mid"=>"mid.1460927154560:342e00fa2b62630475", "seq"=>8, "text"=>"tabling"}}]}]}}
image_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927497761, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927497726, "message"=>{"mid"=>"mid.1460927497583:349be21f279045c561", "seq"=>11, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://scontent.xx.fbcdn.net/hphotos-xpl1/v/t34.0-12/13022191_10209212088048439_282983228_n.png?oh=5be8884b70e75af07b0900e46ee1c882&oe=57166DEC"}}]}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927497761, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927497726, "message"=>{"mid"=>"mid.1460927497583:349be21f279045c561", "seq"=>11, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://scontent.xx.fbcdn.net/hphotos-xpl1/v/t34.0-12/13022191_10209212088048439_282983228_n.png?oh=5be8884b70e75af07b0900e46ee1c882&oe=57166DEC"}}]}}]}]}}
sticker_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927478363, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927478320, "message"=>{"mid"=>"mid.1460927478306:04f9aa2f5e629e5688", "seq"=>10, "sticker_id"=>209575352566300, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xtf1/t39.1997-6/p100x100/851577_209575355899633_2072364476_n.png"}}]}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927478363, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927478320, "message"=>{"mid"=>"mid.1460927478306:04f9aa2f5e629e5688", "seq"=>10, "sticker_id"=>209575352566300, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xtf1/t39.1997-6/p100x100/851577_209575355899633_2072364476_n.png"}}]}}]}]}}
like_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927519247, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927519219, "message"=>{"mid"=>"mid.1460927519209:2d667cda3db4ff8910", "seq"=>12, "sticker_id"=>369239263222822, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xfa1/t39.1997-6/851557_369239266556155_759568595_n.png"}}]}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927519247, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927519219, "message"=>{"mid"=>"mid.1460927519209:2d667cda3db4ff8910", "seq"=>12, "sticker_id"=>369239263222822, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xfa1/t39.1997-6/851557_369239266556155_759568595_n.png"}}]}}]}]}}
postback_params = {"object"=>"page", "entry"=>[{"id"=>1709967682591538, "time"=>1460929057849, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1709967682591538}, "timestamp"=>1460929057849, "postback"=>{"payload"=>"help"}}]}], "controller"=>"pablo", "action"=>"pablo", "pablo"=>{"object"=>"page", "entry"=>[{"id"=>1709967682591538, "time"=>1460929057849, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1709967682591538}, "timestamp"=>1460929057849, "postback"=>{"payload"=>"help"}}]}]}}

params = sticker_params


def controller_action(params)
	messaging_events = FBParser.messaging_events(params)
    messaging_events.each do |event|
      event = FBMessage.new(event)
      if event.is_pablo_command?
      	Pablo.execute(event)
      else
      	puts params
      	# partner_id = event.sender_id
      	# if event.message
      	# 	Pablo.send(partner_id, event.message)
      	# else
      	# 	Pablo.send(event.sender_id, {:text => 'I cant send that type of message'})
      	# end
      end
    end
end

# controller_action(params)

# BotMember.all.each do |bm|
# 	name = bm.group_aliases.join(', ')
# 	Pablo.send(bm.sender_id, {:text => "Hi Friend! Because my knowledge is limited, I've decided to pair you up with a secret PBL friend, #{name}, who can help me respond"})
# 	Pablo.send(bm.sender_id, {:text => "Your typical commands (tabling, blog, points, etc) will still go to me but I'll be forwarding rest to #{name}. You can even just chat with #{name} anonymously if you wish!"})
# 	Pablo.send(bm.sender_id, {:text => "Try it out by sending a random message to me, and check my menu by (Y) for more details!"})
# end
