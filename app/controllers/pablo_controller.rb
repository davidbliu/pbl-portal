class PabloController < ApplicationController
  skip_before_filter :is_signed_in
  def hook
    render text: params["hub.challenge"]
  end

  def pablo_test
    q = params[:q]
    sender_id = '951139591673712'
    resp = Pablo.get_response(sender_id, q)
    Pablo.send("951139591673712", resp)
    # r = Pablo.get_me(sender_id)
    render json: resp
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
