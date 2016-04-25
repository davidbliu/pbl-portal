require "uri"
require 'rest-client'

class Pablo
  def self.david_id
    951139591673712
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

  def self.send(recipient_id, msg)
    token = 'EAAHxkxJBZAosBAL6FZBRIM2wJ990bGqDNqDARI4lnHbzQT5yvsNEogZCivDMhMCquWwvgIZCkcZBvQChEbiP7DGL2jlQeSUOHgbddYK3fwcRDIDWdXeLegZA6NNUUZAWJRcRj0iZCO6AsbwjUZARjfFXeENyeMOlfkTbqYpICgMuT1gZDZD'
    body = {:recipient => {:id => recipient_id}, :message => msg}
    fb_url = 'https://graph.facebook.com/v2.6/me/messages?access_token='+token
    begin
    RestClient.post fb_url, body.to_json, :content_type => :json, :accept => :json
    rescue => e
      puts '>>> ERROR in Pablo::send, the rest client response was '
      puts e.response
      puts 'id: '+recipient_id.to_s
    end
  end

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



  def self.send_pairing_info(id, bot)
    p1 = {:text => "Hey #{bot.get_alias}, I've paired you up with a secret friend in PBL who can help answer questions on my behalf. You'll known them by an alias only"}
    p2 = {:text => "Your name is #{bot.get_alias} and #{bot.pairing_info}"}
    p3 = {:text => "If you want a new secret friend, just type skip."}
    self.send(id, p1)
    self.send(id, p2)
    self.send(id, p3)
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
      self.send(event.sender_id, self.go_response(member, event.msg))
    when :tabling
      self.send(event.sender_id, self.tabling_response(member))
    when :points
      self.send(event.sender_id, self.points_response(member))
    when :events
      self.send(event.sender_id, self.events_response)
    when :blog
      self.send(event.sender_id, self.blog_response(member))
    when :more_blog
      more_blog_responses = self.more_blog_responses(member)
      self.send(event.sender_id, more_blog_responses[0])
      self.send(event.sender_id, more_blog_responses[1])
      self.send(event.sender_id, more_blog_responses[2])
    when :help
      self.send(event.sender_id, self.help_response(member))
    when :joke
      self.send(event.sender_id, self.joke_response)
    when :wiki
      self.send(event.sender_id, self.wiki_response(event.msg))
    when :skip
      self.send(event.sender_id, {:text => 'Finding you a new partner'})
      event.bot.skip
    when :pair
      bot_alias = event.msg.split('pair ')[1]
      if event.bot.pair(bot_alias)
        event.bot.alert_group
      else
        self.send(event.sender_id, {:text=> 'Unable to perform pairing'})
      end
    when :group
      event.bot.alert_group
    when :whoami
      self.send(event.sender_id, {:text => event.bot.alias})
    when :info_pair
      self.send_pairing_info(event.sender_id, event.bot)
    when :topic
      event.bot.send_topic
    when :candidates
      self.send(event.sender_id, DefaultMessage.platforms)
    when :support
      name = event.msg.split("support ")[1]
      self.send(event.sender_id, {:text => "I'll let #{name} know of your support!"})
    when :platform_for
      name = event.msg.split("platform_for ")[1]
      self.send(event.sender_id, {:text => "Here's the platforms for #{name}"})
      DefaultMessage.platform_for(event.sender_id, name)
    when :pokemon
      correct_guesses = ["squirtle", "snorlax"]
      correctgex = Regexp.new(correct_guesses.join('|'))
      if (event.msg.downcase =~ correctgex) != nil
        event.bot.send_puppy
      end
    when :boba
      self.send(event.sender_id, DefaultMessage.boba_msg)
    when :boba_example
      self.send(event.sender_id, {:text => "Here's an example of how to send your order!"})
      self.send(event.sender_id, DefaultMessage.boba_order_example)
      self.send(event.sender_id, DefaultMessage.boba_address_example)
    when :boba_order
      order = event.msg.downcase.split('order:')[1]
      b = Boba.where(name: event.bot.name).first_or_create!
      b.order = order
      b.save!
      buttons = [{
        type:'postback',
        payload: 'Boba Order',
        title:"Check my order"
        }]
      self.send(event.sender_id, self.get_button_msg("Got it! I'll get you an order of \"#{order}\"", buttons))
    when :boba_address
      address = event.msg.downcase.split('address:')[1]
      b = Boba.where(name: event.bot.name).first_or_create!
      b.address = address
      b.save!
      buttons = [{
        type:'postback',
        payload: 'Boba Order',
        title:"Check my order"
        }]
      self.send(event.sender_id, self.get_button_msg("Got it! I'll send your order of \"#{b.order}\" to \"#{address}\"", buttons))
    when :order_confirmation
      self.send(event.sender_id, DefaultMessage.order_confirmation(event.bot))
    when :cancel_boba
      Boba.find_by_name(event.bot.name).destroy
      self.send(event.sender_id, {:text => "Okay!"})
    when :show_order 
      boba = Boba.find_by_name(event.bot.name)
      if boba.nil?
        self.send(event.sender_id, {:text => "You didn't place an order, #{event.bot.name}"})
      else
        self.send(event.sender_id, {:text => "You ordered #{boba.order} to be sent to #{boba.address}"})
      end
    when :generate
      TablingManager.gen_tabling
      buttons = [{
        type:'web_url',
        url:'http://portal.berkeley-pbl.com/tabling',
        title:'pbl.link/tabling'
      }]
      self.send(event.sender_id, self.get_button_msg("Tabling generated", buttons))
    when :pablo

    else
      self.send(event.sender_id, {:text => 'oops i fudged'})
    end
  end
end
