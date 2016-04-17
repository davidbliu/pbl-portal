require "uri"
require "net/http"
require 'rest-client'

class Pablo
  def self.send_message(sender_id, text)
    token = 'EAAHxkxJBZAosBAL6FZBRIM2wJ990bGqDNqDARI4lnHbzQT5yvsNEogZCivDMhMCquWwvgIZCkcZBvQChEbiP7DGL2jlQeSUOHgbddYK3fwcRDIDWdXeLegZA6NNUUZAWJRcRj0iZCO6AsbwjUZARjfFXeENyeMOlfkTbqYpICgMuT1gZDZD'
    body = {:recipient => {:id => sender_id}, :message => {:text=> text}}
    fb_url = 'https://graph.facebook.com/v2.6/me/messages?access_token='+token
    RestClient.post fb_url, body.to_json, :content_type => :json, :accept => :json
  end

  def self.handle_tabling(email)
    slots = TablingSlot.all.select{|x| x.member_emails.include?(email)}
    if slots.length == 0
      return 'You dont have to table!'
    end
    resp = ''
    slots.each do |slot|
      r = 'You are tabling at '+slot.time_string+' with '+Member.where('email in (?)', slot.member_emails).pluck(:name).uniq.join(', ')
      puts r
      resp += r
    end
    return resp
  end

  def self.handle_blog(me)
    return Post.last.title
  end

  def self.handle_events(sender_id, me)
    self.send_message(sender_id, 'not implemented yet')
  end

  def self.respond_to_message(sender_id, text)
    text = text.downcase
    splits = text.split(' ')
    begin
      if splits[0] == 'iam'
        BotMember.where(sender_id: sender_id).destroy_all
        BotMember.where(email: splits[1], sender_id: sender_id).first_or_create!
        self.send_message(sender_id, 'you are '+splits[1])
        return 
      else
        bot_member = BotMember.find_by_sender_id(sender_id)
        if not bot_member or bot_member == nil
          self.send_message(sender_id, 'Idk who you even are...let my know by typing "iam <<youremailhere>>"')
          return
        end
        me = Member.find_by_email(bot_member.email)
        if not me or me == nil
          self.send_message(sender_id, 'It seems you dont have an account on the portal, try "iam <<adifferentemail>>"')
          return
        end
        case splits[0]
        when 'help'
          self.send_message(sender_id, 'you can do: go <key>, tabling, blog, events, whoami')
        when 'whoami'
          self.send_message(sender_id, 'You are '+me.email)
        when 'generate'
          TablingManager.gen_tabling
          self.send_message(sender_id, 'You generated tabling, check it out at http://pbl.link/tabling')
        when 'points'
          self.send_message(sender_id, 'Your points: '+Event.get_score(me.email).to_s)
        when 'tabling'
          self.send_message(sender_id, self.handle_tabling(me.email))
        when 'go'
          key = splits[1]
          urls = GoLink.where(key: key).pluck(:url).join(', ')
          self.send_message(sender_id, urls)
        when 'blog'
          self.send_message(sender_id, self.handle_blog(me))
        when 'events'
          self.handle_events(sender_id, me)
        else
          if Member.committees.include?(text.upcase)
            resp = Member.get_group(text).pluck(:name).join(', ')
            self.send_message(sender_id,resp)
            return 
          end
          msg = 'I dont know how to respond to "'+text+'", type "help" to see what I know'
          self.send_message(sender_id, msg)
        end
      end
    rescue
      self.send_message(sender_id, 'error')
    end
  end
end
