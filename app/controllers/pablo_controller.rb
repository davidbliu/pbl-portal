class PabloController < ApplicationController
  skip_before_filter :is_signed_in
  def hook
    render text: params["hub.challenge"]
  end

  def pablo_test
    q = params[:q]
    sender_id = '95113959167371'
    resp = Pablo.get_response(sender_id, q)
    Pablo.send("951139591673712", resp)
    render json: resp
  end


  def pablo
    messaging_events = params[:entry][0][:messaging]
    mhash = {}
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
      end
    end
    mhash.keys.each do |key|
      m = mhash[key]
      resp = Pablo.get_response(m[:sender_id], m[:message])
      Pablo.send(m[:sender_id], resp)
    end

    render nothing: true, status: 200
  end
end
