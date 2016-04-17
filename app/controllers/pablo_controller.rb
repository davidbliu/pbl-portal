class PabloController < ApplicationController
  skip_before_filter :is_signed_in
  def hook
    render text: params["hub.challenge"]
  end

  def pablo
    puts 'hi i just got a message'
    puts params[:entry]
    messaging_events = params[:entry][0][:messaging]
    mhash = {}
    puts 'i just got the events'
    messaging_events.each do |event|
      begin
        sender_id = event["sender"]["id"]
        message_id = event["message"]["seq"]
        if event["message"].keys.include?("text")
          message = event["message"]["text"]
        else
          message = "I can't respond to that kind of message"
        end
        mhash[message_id] = {sender_id: sender_id, message: message}
      rescue
        puts 'this failed'
      end
    end
    mhash.keys.each do |key|
      m = mhash[key]
      Pablo.respond_to_message(m[:sender_id], m[:message])
    end

    render nothing: true, status: 200
  end
end
