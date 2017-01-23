require "uri"
require 'rest-client'

class Pablo
  def self.david_id
    951139591673712
  end

  def self.pablo_admin
    ['david.yan@berkeley.edu', 'justin.mi@berkeley.edu', 'wilson1.yan@berkeley.edu', 'jackzhang1067@berkeley.edu']
  end

   def self.help_response(member)
    return {
    attachment: {
      type: "template",
      payload: {
        template_type: "generic",
        elements: [
          {
            title: "Secret Pairings",
            subtitle: "I've partnered you with a secret friend to help me respond.",
            buttons: [
              {
                type: 'postback',
                payload: 'group',
                title: "Who's My Partner?"
              },
              {
                type: 'postback',
                payload: 'skip',
                title: 'Skip Partner'
              },
              {
                type:'postback',
                payload:'info_pair',
                title:'More Info'
              }
            ]

          },
          {
            title: "Blog",
            subtitle:"Check out recent blogposts",
            buttons:[
              {
                type:"web_url",
                url:"http://portal.berkeley-pbl.com/blog",
                title:"pbl.link/blog"
              },
              {
                type:"postback",
                payload:"blog",
                title:"Recent posts"
              }          
            ]
          },
          {
            title:"Tabling",
            subtitle: 'I can tell you when your tabling slot is',
            buttons:[
              {
                type:'postback',
                payload:'tabling',
                title:'My Slot'
              },
              {
                type:"web_url",
                url:"http://portal.berkeley-pbl.com/tabling",
                title:"Full schedule"
              }

            ]
          },
          {
            title:"Events",
            subtitle: 'Here are some events happening this week',
            buttons: self.event_buttons
          },
          {
            title:"Points",
            subtitle: self.points_string(member),
            buttons:[
              {
                type:"web_url",
                url:"http://portal.berkeley-pbl.com/points",
                title:"Attendance"
              },
              {
                type:"web_url",
                url:"http://portal.berkeley-pbl.com/points/scoreboard",
                title:"Scoreboard"
              },
              {
                type:"web_url",
                url:"http://portal.berkeley-pbl.com/points/distribution",
                title:"Distribution"
              }         
            ]
          },
          {
            title: 'More',
            subtitle: 'I can also...',
            buttons:[
              {
                type: 'postback',
                payload: 'joke',
                title: 'Tell you a joke'
              }
            ]
          }
        ]
      }
    }
  }
  end

  def self.go_response(member, msg)
    msg = msg.downcase
    key = msg.split('go ')[1]
    golinks = GoLink.where(key: key).where('id in (?)', GoLink.can_view(member.email))
    if golinks.length == 0
      search = GoLink.email_search(key, member.email).first(3)
      buttons = []
      search.each do |golink|
        btn = {
          type: 'web_url',
          url: golink[:url],
          title: golink[:key]
        }
        buttons << btn
      end
      text = 'Couldnt find "'+key+'", did you mean one of these?'
    else
      buttons = []
      golinks.each do |golink|
        buttons << {
          type:'web_url',
          url: golink.url,
          title: golink.url
        }
      end
      if key
        text = 'Found "'+key+'", click to go'
      else
        text = 'click to go'
      end
    end
    if buttons.length == 0
      return {:text => "I couldn't find any results for that :("}
    else
      return self.get_button_msg(text, buttons)
    end
  end
  
  def self.wiki_response(msg)
    q = msg.split('wiki ')[1]
    buttons = [{
      type:'web_url',
      title: 'View wiki result',
      url: 'http://wd.berkeley-pbl.com/wiki/index.php/Special:Search/'+URI.encode(q)
      }]
    return self.get_button_msg('I searched "'+q+'" for you on the wiki', buttons)
  end
  def self.tabling_string(member)
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
    return tabling_msg
  end

  def self.points_string(member)
    'You have '+Event.get_score(member.email).to_s+' points'
  end

  def self.points_response(member)
    {:text => self.points_string(member)}
  end

  def self.trending_golink_buttons(member)
    golinks = GoLink.order('created_at desc').where('id in (?)', GoLink.can_view(member.email)).first(3)
    buttons = []
    golinks.each do |golink|
      buttons << {
        type: 'web_url',
        title: golink.key,
        url: golink.url
      }
    end
    return buttons
  end

  def self.tabling_response(member)
    tabling_msg = self.tabling_string(member)
    buttons = [{
      type:'web_url',
      url:'http://pbl.link/tabling',
      title:'Full tabling schedule'
      }]
    return self.get_button_msg(tabling_msg, buttons)
  end

  # def self.send(recipient_id, msg)
  #   token = 'EAAHxkxJBZAosBAL6FZBRIM2wJ990bGqDNqDARI4lnHbzQT5yvsNEogZCivDMhMCquWwvgIZCkcZBvQChEbiP7DGL2jlQeSUOHgbddYK3fwcRDIDWdXeLegZA6NNUUZAWJRcRj0iZCO6AsbwjUZARjfFXeENyeMOlfkTbqYpICgMuT1gZDZD'
  #   body = {:recipient => {:id => recipient_id}, :message => msg}
  #   fb_url = 'https://graph.facebook.com/v2.6/me/messages?access_token='+token
  #   begin
  #   RestClient.post fb_url, body.to_json, :content_type => :json, :accept => :json
  #   rescue => e
  #     puts '>>> ERROR in Pablo::send, the rest client response was '
  #     puts e.response
  #     puts 'id: '+recipient_id.to_s
  #   end
  # end

  def self.post_button(post)
    {
        type: 'web_url',
        url: 'http://portal.berkeley-pbl.com/blog/post/'+post.id.to_s,
        title: post.title
      }
  end

  def self.blog_response(member)
    buttons = []
    Post.list(member).first(3).each do |post|
      buttons << self.post_button(post)
    end
    return self.get_button_msg('Here are some recent blog posts! Want more? say "more blog"', buttons)
  end

  def self.more_blog_responses(member)
    buttons = []
    list = Post.list(member)
    if list.length >= 9
      l = [list[0..2], list[3..5], list[6..8]]
      btns = []
      l.each do |posts|
        buttons = []
        posts.each do |post|
          btn = self.post_button(post)
          buttons << btn
        end
        btns << buttons
      end
      r1 = self.get_button_msg('More blog posts', btns[0])
      r2 = self.get_button_msg('...', btns[1])
      r3 = self.get_button_msg('...', btns[2])
      return [r1, r2, r3]
    end
  end

  def self.events_response
    return self.get_button_msg('Here are some events this week', event_buttons)
  end

  def self.get_button_msg(title, buttons)
    return {
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button', 
          text: title,
          buttons: buttons
        }
      }
    }
  end

  def self.event_buttons
    buttons = []
    buttons << {
      type:'web_url',
      url:'https://calendar.google.com/calendar/embed?src=8bo2rpf4joem2kq9q2n940p1ss@group.calendar.google.com&ctz=America/Los_Angeles',
      title: 'View Calendar'
    }
    buttons << {
      type:'web_url',
      url: 'https://calendar.google.com/calendar/render?eid=OTNrMjlmZDRzdGJwdDA4ZjNqZWdtMDJqbDggOGJvMnJwZjRqb2VtMmtxOXEybjk0MHAxc3NAZw&ctz=America/Los_Angeles&sf=true&output=xml#eventpage_6',
      title: 'PD Apprentice Challenge'
    }
    buttons << {
      type: 'web_url',
      url: 'https://calendar.google.com/calendar/render?eid=Z2kwYWQyb2Zta3NvMnA1b2hzN3BmdTIzZXMgOGJvMnJwZjRqb2VtMmtxOXEybjk0MHAxc3NAZw&ctz=America/Los_Angeles&sf=true&output=xml#main_7',
      title: 'Fourth General Meeting'
    }
    return buttons
  end
  def self.default_btns(text)
    buttons = []
    buttons << {
      type: 'web_url',
      url: 'http://wd.berkeley-pbl.com/wiki/index.php/Special:Search/'+URI.encode(text),
      title: 'Search the wiki'
    }
    buttons << {
      type: 'postback',
      payload: 'help',
      title: 'Help'
    }
    title = 'I dont know how to do "'+text+'", here are some suggestions'
    return self.get_button_msg(title, buttons)
  end

  def self.send_pablo_update_warning
    message = {:text => "Hi we are going to pair you with someone new in one hour! If you'd like to tell your partner who you are do so now!"}
    Pablo.get_active_bot_members.each do |bot|
      bot.send_msg(message)
    end
  end

  def self.send_pairing_all
    Pablo.get_active_bot_members.each do |bot|
      message1 = {:text => "Hey #{bot.get_alias}, I've paired you with a new secret friend in PBL. #{bot.pairing_info}"}
      message2 = {:text => "If you want a new secret friend, just type skip."}
      bot.send_msg(message1)
      bot.send_msg(message2)
    end
  end
  
  def self.send_pairing_info(bot)
    p1 = {:text => "Hey #{bot.get_alias}, I've paired you up with a secret friend in PBL who can help answer questions on my behalf. You'll known them by an alias only"}
    p2 = {:text => "Your name is #{bot.get_alias} and #{bot.pairing_info}"}
    p3 = {:text => "If you want a new secret friend, just type skip."}
    bot.send_msg(p1)
    bot.send_msg(p2)
    bot.send_msg(p3)
  end

  def self.joke_response
    joke_url = 'http://tambal.azurewebsites.net/joke/random'
    r = RestClient.get joke_url, :content_type => :json, :accept => :json
    joke = JSON.parse(r)["joke"]
    return {:text => joke}
  end

  def self.execute(event)
    # member = BotMember.get_member_from_id(event.sender_id)
    member = event.member
    case event.pablo_method
    when :go
      event.bot.send_msg(self.go_response(member, event.msg))
    when :tabling
      event.bot.send_msg(self.tabling_response(member))
    when :points
      event.bot.send_msg(self.points_response(member))
    when :events
      event.bot.send_msg(self.events_response)
    when :blog
      event.bot.send_msg(self.blog_response(member))
    when :more_blog
      more_blog_responses = self.more_blog_responses(member)
      event.bot.send_msg(more_blog_responses[0])
      event.bot.send_msg(more_blog_responses[1])
      event.bot.send_msg(more_blog_responses[2])
    when :help
      event.bot.send_msg(self.help_response(member))
    when :joke
      event.bot.send_msg(self.joke_response)
    when :wiki
      event.bot.send_msg(self.wiki_response(event.msg))
    when :skip
      event.bot.send_msg({:text => 'Finding you a new partner'})
      event.bot.skip
    when :pair
      bot_alias = event.msg.split('pair ')[1]
      if event.bot.pair(bot_alias)
        event.bot.alert_group
      else
        event.bot.send_msg({:text=> 'Unable to perform pairing'})
      end
    when :group
      event.bot.alert_group
    when :whoami
      event.bot.send_msg({:text => event.bot.alias})
    when :info_pair
      self.send_pairing_info(event.bot)
    when :topic
      event.bot.send_msg_topic
    when :candidates
      event.bot.send_msg(DefaultMessage.platforms)
    when :support
      name = event.msg.split("support ")[1]
      event.bot.send_msg({:text => "I'll let #{name} know of your support!"})
    when :platform_for
      name = event.msg.split("platform_for ")[1]
      event.bot.send_msg({:text => "Here's the platforms for #{name}"})
      DefaultMessage.platform_for(event.sender_id, name)
    when :pokemon
      correct_guesses = ["squirtle", "snorlax"]
      correctgex = Regexp.new(correct_guesses.join('|'))
      if (event.msg.downcase =~ correctgex) != nil
        event.bot.send_msg_puppy
      end
    when :generate
      TablingManager.gen_tabling
      buttons = [{
        type:'web_url',
        url:'http://portal.berkeley-pbl.com/tabling',
        title:'pbl.link/tabling'
      }]
      event.bot.send_msg(self.get_button_msg("Tabling generated", buttons))
    when :pablo

    else
      event.bot.send_msg({:text => 'oops i fudged'})
    end
  end

  def self.create_pairs
    Rails.logger.debug('Creating pairs')
    members = Pablo.get_active_bot_members
    members, pairs = Pablo.generate_pairs(members, false)
    Pablo.assign_pairs(members, pairs)
    Rails.logger.debug('Done')
  end

  def self.reupdate_pairs
    Rails.logger.debug('Reupdating randomized pairings')
    members = Pablo.get_active_bot_members
    members, pairs = Pablo.generate_pairs(members, false)
    Pablo.assign_pairs(members, pairs)
    Rails.logger.debug('Finished')
  end

  def self.assign_pairs(members, member_groups)
    Rails.logger.debug('Assigning Pairs')
    n = members.length
    (0...n).each do |i|
      BotMember.where(:id => members[i].id).update_all(:group_id => member_groups[i])
    end
  end

  def self.get_active_bot_members
    Rails.logger.debug('Getting active bot member')
    members = []
    Member.where(:is_active => true).each do |m|
      member = BotMember.where(:name => m.name).take
      if member != nil
        members << member
      end
    end  
    return members
  end

  def self.generate_pairs(members, need_check)
    Rails.logger.debug('Generating pairs')
    members = members.shuffle
    member_groups = []
    num_members = members.length
    (0...num_members).each do |i| 
      member_groups << i / 2
    end
    if num_members % 2 == 1
      member_groups[-1] = member_groups[-2]
    end
    
    if need_check && !check(members, member_groups)
     members, member_groups = self.generate_pairs(members, true) 
    end

    return members, member_groups
  end

  def self.check(members, member_groups)
    e = members.select { |m| m == nil }
    num_members = members.length
    (0...num_members/2).each do |i|
      member = members[2*i]
      partner = members[2*i+1]
      last_group = members.select do |m|
        m.group_id == member.group_id 
      end
      last_group.each { |m| Rails.logger.debug(m.name) }
      if last_group.select { |m| m.name == partner.name }.length > 0
        return false
      end
    end

    return true
  end

  def self.update_tabling_all
    Pablo.get_active_bot_members.each do |bot|
      member = Member.where(:name => bot.name).first
      msg1 = {:text => "Hi tabling has just been updated!"}
      msg2 = {:text => Pablo.tabling_string(member)}
      bot.send_msg(msg1)
      bot.send_msg(msg2)
    end
  end

  def self.broadcast_all(msg)
    BotMember.all.each do |bot|
      bot.send_msg({:text => msg})
    end
  end

  def self.reset_aliases
    BotMember.update_all(:alias => nil)
    BotMember.all.each do |bot|
      if !Member.where(:is_active => true).where(:name => bot.name).nil?
        bot.generate_alias
    end
  end
end
