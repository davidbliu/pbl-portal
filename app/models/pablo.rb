require "uri"
require "net/http"
require 'rest-client'

class Pablo
  # def self.get_response(member, msg)
  #   msg = msg.downcase
  #   if self.blog_message?(msg)
  #     return 'this is a blog message'
  #   elsif self.tabling_message?(msg)
  #     return self.handle_tabling(member, msg)
  #   elsif self.go_message?(msg)
  #     return self.handle_go(member, msg)
  #   end
  #   return {:text=>msg}
  # end

  # def self.blog_message?(msg)
  #   msg.include?('blog')
  # end

  # def self.tabling_message?(msg)
  #   msg.include?('tabling')
  # end

  # def self.go_message?(msg)
  #   msg.split(' ')[0] == 'go'
  # end

  def self.handle_go(member, msg)
    key = msg.split('go ')[1]
    urls = GoLink.where(key: key).where('id in (?)', GoLink.can_view(member.email)).pluck(:url)
    if urls.length == 0
      msg = 'Did you mean one of these?: '+GoLink.email_search(key, member.email).map{|x| x[:key]}.join(', ')
    else
      msg = urls.join(', ')
    end
    return {:text=>msg}
  end

  def self.handle_tabling(member, msg)
    tabling_msg = ''
    slots = TablingSlot.all.select{|x| x.member_emails.include?(member.email)}
    slots.each do |slot|
      names = Member.where('email in (?)', slot.member_emails).pluck(:name).uniq.join(', ')
      str = 'You are tabling at '+slot.time_string+' with '+names
      tabling_msg += str
    end
    if tabling_msg == ''
      tabling_msg = 'You dont have to table'
    end
    return {:text => tabling_msg}
  end

#   def self.send_text_message(sender_id, text)
#     msg = {:text=> text}
#     self.send_message(sender_id, text)
#   end

  def self.send(recipient_id, msg)
    token = 'EAAHxkxJBZAosBAL6FZBRIM2wJ990bGqDNqDARI4lnHbzQT5yvsNEogZCivDMhMCquWwvgIZCkcZBvQChEbiP7DGL2jlQeSUOHgbddYK3fwcRDIDWdXeLegZA6NNUUZAWJRcRj0iZCO6AsbwjUZARjfFXeENyeMOlfkTbqYpICgMuT1gZDZD'
    body = {:recipient => {:id => recipient_id}, :message => msg}
    fb_url = 'https://graph.facebook.com/v2.6/me/messages?access_token='+token
    begin
    RestClient.post fb_url, body.to_json, :content_type => :json, :accept => :json
    rescue => e
      puts 'the response was '
      puts e.response
    end
  end

  def self.handle_blog(member)
    buttons = []
    Post.list(member).first(3).each do |post|
      btn = {
        type: 'web_url',
        url: 'http://portal.berkeley-pbl.com/blog/post/'+post.id.to_s,
        title: post.title
      }
      buttons << btn
    end
    return {
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button', 
          text: 'Here are '+buttons.length.to_s+' recent blogposts', 
          buttons: buttons
        }
      }
    }
  end


  def self.default_btns(text)
    buttons = []
    buttons << {
      type: 'web_url',
      url: 'http://wd.berkeley-pbl.com/wiki/index.php/Special:Search/'+text,
      title: 'Search the wiki'
    }
    buttons << {
      type: 'web_url',
      url: 'https://www.google.com/?gws_rd=ssl#q='+text,
      title: 'Google it'
    }

    return {
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button', 
          text: 'I dont know how to do "'+text+'", here are some suggestions', 
          buttons: buttons
        }
      }
    }
  end

  def self.get_response(sender_id, text)
    text = text.downcase
    splits = text.split(' ')
    begin
      if splits[0].include?('@') and splits[0].include?('.')
        BotMember.where(sender_id: sender_id).destroy_all
        BotMember.where(email: splits[0], sender_id: sender_id).first_or_create!
        return {:text => 'You are '+text}
      else
        bot_member = BotMember.where(sender_id: sender_id)
        if bot_member.length == 0
          return {:text =>'First things first! whats your email?'}
        end
        bot_member = bot_member.first
        me = Member.where(email: bot_member.email)
        if me.length == 0
          return {:text => 'This email doesnt have an account on the portal, try a different email'}
        end
        me = me.first
        case splits[0]
        when 'help'
          return {:text=> 'random random helptext'}
        when 'whoami'
          return {:text => me.name.to_s}
        when 'generate'
          TablingManager.gen_tabling
          return {:text => 'You generated tabling, check it out at http://pbl.link/tabling'}
        when 'points'
          return {:text=> 'Your points: '+Event.get_score(me.email).to_s}
        when 'tabling'
          return self.handle_tabling(me, text)
        when 'go'
          return self.handle_go(me, text)
        when 'blog'
          return self.handle_blog(me)
        when 'events', 'c', 'calendar', 'cal'
          return {:text=>'http://pbl.link/calendar'}
        end

        if Member.committees.include?(text.upcase)
          names = Member.get_group(text).pluck(:name).join(', ')
          return {:text=>names}
        end
        return self.default_btns(text)
      end
    rescue => error
      return {:text => error.to_s}
    end
  end
end
