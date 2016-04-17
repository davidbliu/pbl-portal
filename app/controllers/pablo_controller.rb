class PabloController < ApplicationController
  skip_before_filter :is_signed_in
  def hook
    render text: params["hub.challenge"]
  end

  def pablo_test
    # text_params = {"object"=>"page", "entry"=>[{"id"=>1709967682591538, "time"=>1460932704020, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1709967682591538}, "timestamp"=>1460932703993, "message"=>{"mid"=>"mid.1460932703980:ae6a21a109d02e6710", "seq"=>2761, "text"=>"blog"}}]}], "controller"=>"pablo", "action"=>"pablo", "pablo"=>{"object"=>"page", "entry"=>[{"id"=>1709967682591538, "time"=>1460932704020, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1709967682591538}, "timestamp"=>1460932703993, "message"=>{"mid"=>"mid.1460932703980:ae6a21a109d02e6710", "seq"=>2761, "text"=>"help"}}]}]}}
    # image_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927497761, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927497726, "message"=>{"mid"=>"mid.1460927497583:349be21f279045c561", "seq"=>11, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://scontent.xx.fbcdn.net/hphotos-xpl1/v/t34.0-12/13022191_10209212088048439_282983228_n.png?oh=5be8884b70e75af07b0900e46ee1c882&oe=57166DEC"}}]}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927497761, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927497726, "message"=>{"mid"=>"mid.1460927497583:349be21f279045c561", "seq"=>11, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://scontent.xx.fbcdn.net/hphotos-xpl1/v/t34.0-12/13022191_10209212088048439_282983228_n.png?oh=5be8884b70e75af07b0900e46ee1c882&oe=57166DEC"}}]}}]}]}}
    # sticker_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927478363, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927478320, "message"=>{"mid"=>"mid.1460927478306:04f9aa2f5e629e5688", "seq"=>10, "sticker_id"=>209575352566300, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xtf1/t39.1997-6/p100x100/851577_209575355899633_2072364476_n.png"}}]}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927478363, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927478320, "message"=>{"mid"=>"mid.1460927478306:04f9aa2f5e629e5688", "seq"=>10, "sticker_id"=>209575352566300, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xtf1/t39.1997-6/p100x100/851577_209575355899633_2072364476_n.png"}}]}}]}]}}
    # like_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927519247, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927519219, "message"=>{"mid"=>"mid.1460927519209:2d667cda3db4ff8910", "seq"=>12, "sticker_id"=>369239263222822, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xfa1/t39.1997-6/851557_369239266556155_759568595_n.png"}}]}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927519247, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927519219, "message"=>{"mid"=>"mid.1460927519209:2d667cda3db4ff8910", "seq"=>12, "sticker_id"=>369239263222822, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xfa1/t39.1997-6/851557_369239266556155_759568595_n.png"}}]}}]}]}}
    # postback_params = {"object"=>"page", "entry"=>[{"id"=>1709967682591538, "time"=>1460929057849, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1709967682591538}, "timestamp"=>1460929057849, "postback"=>{"payload"=>"blog"}}]}], "controller"=>"pablo", "action"=>"pablo", "pablo"=>{"object"=>"page", "entry"=>[{"id"=>1709967682591538, "time"=>1460929057849, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1709967682591538}, "timestamp"=>1460929057849, "postback"=>{"payload"=>"help"}}]}]}}
    # params = image_params

    responses = []
    seen = []
    messaging_events = FBParser.messaging_events(params)
    messaging_events.each do |event|
      type = FBParser.message_type(event)
      case type
      when 'text'
        sender_id = FBParser.sender_id(event)
        text = FBParser.get_text(event)
        seq = FBParser.get_seq(event)
        member = BotMember.get_member_from_id(sender_id)
        if member and text != '' and not seen.include?(seq)
          response = Pablo.get_response(member, text)
          Pablo.send(sender_id, response)
          seen << seq
        end
      when 'image'
        sender_id = FBParser.sender_id(event)
        response = {:text=> 'I cant reply to images'}
        Pablo.send(sender_id, response)
      when 'postback'
        sender_id = FBParser.sender_id(event)
        text = FBParser.get_postback(event)
        seq = FBParser.get_seq(event)
        member = BotMember.get_member_from_id(sender_id)
        if member and text != '' and not seen.include?(seq)
          response = Pablo.get_response(member, text)
          Pablo.send(sender_id, response)
          seen << seq
        end
      when 'like'
        sender_id = FBParser.sender_id(event)
        seq = FBParser.get_seq (event)
        member = BotMember.get_member_from_id(sender_id)
        if not seen.include?(seq) and member
          response = Pablo.get_generic_message(member)
          Pablo.send(sender_id, response)
          seen << seq 
        end
      when 'unknown'
        response = {:text => 'I am unable to respond to that type of message'}
      end
      responses << response
    end
    render json: responses
  end


  def pablo
    puts 'pablo'
    messaging_events = params[:entry][0][:messaging]
    mhash = {}
    messaging_events.each do |event|
      puts event
      begin
        message = ''
        sender_id = event["sender"]["id"]
        if event.keys.include?("postback")
          message = event["postback"]["payload"]
          message_id = "POSTBACK"
        elsif event.keys.include?("message")
          message_id = event["message"]["seq"]
          if event["message"].keys.include?("text")
            message = event["message"]["text"]
          else
            message = "I can't respond to that kind of message"
          end
        end
        if message and message != ''
          mhash[message_id] = {sender_id: sender_id, message: message}
        end
      rescue
      end
    end
    puts 'there are '+mhash.keys.length.to_s+' keys!'
    mhash.keys.each do |key|
      m = mhash[key]
      resp = Pablo.get_response(m[:sender_id], m[:message])
      if resp
        Pablo.send(m[:sender_id], resp)
      end
    end

    render nothing: true, status: 200
  end
end
