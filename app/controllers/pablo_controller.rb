class PabloController < ApplicationController
  skip_before_filter :is_signed_in



  def hook
    render text: params["hub.challenge"]
  end

  def boba
    @orders = Boba.all
  end

def admin
  @bots = BotMember.all
end

def admin_send
  bot = BotMember.find(params[:id])
  bot.send_msg({:text => params[:msg]})
  render nothing: true, status: 200
  end





def pablo
    # text = params[:q]
    # text_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927154601, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927154572, "message"=>{"mid"=>"mid.1460927154560:342e00fa2b62630475", "seq"=>8, "text"=>text}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927154601, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927154572, "message"=>{"mid"=>"mid.1460927154560:342e00fa2b62630475", "seq"=>8, "text"=>"tabling"}}]}]}}
    # image_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927497761, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927497726, "message"=>{"mid"=>"mid.1460927497583:349be21f279045c561", "seq"=>11, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://scontent.xx.fbcdn.net/hphotos-xpl1/v/t34.0-12/13022191_10209212088048439_282983228_n.png?oh=5be8884b70e75af07b0900e46ee1c882&oe=57166DEC"}}]}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927497761, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927497726, "message"=>{"mid"=>"mid.1460927497583:349be21f279045c561", "seq"=>11, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://scontent.xx.fbcdn.net/hphotos-xpl1/v/t34.0-12/13022191_10209212088048439_282983228_n.png?oh=5be8884b70e75af07b0900e46ee1c882&oe=57166DEC"}}]}}]}]}}
    # sticker_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927478363, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927478320, "message"=>{"mid"=>"mid.1460927478306:04f9aa2f5e629e5688", "seq"=>10, "sticker_id"=>209575352566300, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xtf1/t39.1997-6/p100x100/851577_209575355899633_2072364476_n.png"}}]}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927478363, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927478320, "message"=>{"mid"=>"mid.1460927478306:04f9aa2f5e629e5688", "seq"=>10, "sticker_id"=>209575352566300, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xtf1/t39.1997-6/p100x100/851577_209575355899633_2072364476_n.png"}}]}}]}]}}
    # like_params = {"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927519247, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927519219, "message"=>{"mid"=>"mid.1460927519209:2d667cda3db4ff8910", "seq"=>12, "sticker_id"=>369239263222822, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xfa1/t39.1997-6/851557_369239266556155_759568595_n.png"}}]}}]}], "controller"=>"application", "action"=>"hook", "application"=>{"object"=>"page", "entry"=>[{"id"=>1725116921106681, "time"=>1460927519247, "messaging"=>[{"sender"=>{"id"=>1055216967870621}, "recipient"=>{"id"=>1725116921106681}, "timestamp"=>1460927519219, "message"=>{"mid"=>"mid.1460927519209:2d667cda3db4ff8910", "seq"=>12, "sticker_id"=>369239263222822, "attachments"=>[{"type"=>"image", "payload"=>{"url"=>"https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xfa1/t39.1997-6/851557_369239266556155_759568595_n.png"}}]}}]}]}}
    # postback_params = {"object"=>"page", "entry"=>[{"id"=>1709967682591538, "time"=>1460929057849, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1709967682591538}, "timestamp"=>1460929057849, "postback"=>{"payload"=>"help"}}]}], "controller"=>"pablo", "action"=>"pablo", "pablo"=>{"object"=>"page", "entry"=>[{"id"=>1709967682591538, "time"=>1460929057849, "messaging"=>[{"sender"=>{"id"=>951139591673712}, "recipient"=>{"id"=>1709967682591538}, "timestamp"=>1460929057849, "postback"=>{"payload"=>"help"}}]}]}}
    # params = text_params  

  puts 'RECEIVED MESSAGE'
  token = 'EAAISyxS1I2MBABvEgMrZAct7oOOdSUc5RYBy6IPtnblsBOyGqUy6x2nmPDMyVPg44YTVytnMRNICNsMgkGosW8bj6SApMtNw1ZBHOy2LFZC7gQPAt42kfs6A202sp5XXk4zbZCVe5wZBTv8ZBicMS4mwQKqw10cvimtZBBL4Uf1JgZDZD'
  # body = {:recipient => {:id => params["entry"][0]["messaging"][0]["sender"]["id"]}, :message => 'hello there'}
  # fb_url = 'https://graph.facebook.com/v2.6/me/messages?access_token='+token
  # begin
  #   RestClient.post fb_url, body.to_json, :content_type => :json, :accept => :json
  # rescue => e
  #   puts 'problem sending message'
  #   puts e
  # end
  sender = params["entry"][0]["messaging"][0]
  event = FBMessage.new(sender)
  event.bot.send_msg({:text => 'Hello World'})
  # seen_seq = []
  # messaging_events = params["entry"][0]["messaging"]
  #   messaging_events.each do |event|
  #     # event = FBMessage.new(event)

  #     # begin
  #       # event = FBMessage.new(event)
  #       # event.bot.log(event.msg)
  #       # if event.is_delivery?
  #       # elsif (event.seq.nil? and not event.is_postback?) or seen_seq.include?(event.seq)
  #       # elsif event.member == nil
  #       #   puts "Pablo doesnt recognize #{event.sender_id}"
  #       # elsif event.is_pablo_command?
  #       #   seen_seq << event.seq
  #       #   begin
  #       #     Pablo.execute(event)
  #       #   rescue
  #       #     event.bot.send_msg({:text => "error"})
  #       #   end
  #       # else
  #       #   seen_seq << event.seq
  #       #   if event.forwarded_message
  #       #     if event.bot.group_id
  #       #       event.bot.group.each do |bot|
  #       #         bot.send_msg(event.forwarded_message)
  #       #       end
  #       #     else
  #       #       event.bot.send_msg({:text => 'Looks like theres no one here...how about a joke'})
  #       #       event.bot.send_msg(Pablo.joke_response)
  #       #     end
  #       #   end
  #       # end
  #     # rescue => e
  #     #   puts 'error in pablo_controller with this message'
  #     #   puts e
  #     #   puts params
  #     # end
  #   end
    # render :text => "received message", status: 200
  render nothing: true, status: 200
end




end
