require "uri"
require 'rest-client'

class Pablo



  def self.handle_go(member, msg)
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
      text = 'Found "'+key+'", click to go'
    end
    if buttons.length == 0
      return {:text => "I couldn't find any results for that :("}
    else
      return self.get_button_msg(text, buttons)
    end
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
    'Your points: '+Event.get_score(member.email).to_s
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

  def self.handle_tabling(member, msg)
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
    return self.get_button_msg('Here are some recent blog posts, for more ask me for "go blog"', buttons)
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
      url:'http://pbl.link/calendar',
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

  def self.get_generic_message(member)
    return {
    attachment: {
      type: "template",
      payload: {
        template_type: "generic",
        elements: [
          {
            title: "Blog",
            image_url:"http://www.ifla.org/files/assets/library-theory-and-research/images/blog-3.jpg",
            subtitle:"View the blog",
            buttons:[
              {
                type:"web_url",
                url:"http://pbl.link/blog",
                title:"Go to the blog"
              },
              {
                type:"postback",
                payload:"blog",
                title:"View recent posts"
              }          
            ]
          },
          {
            title:"Tabling",
            image_url:"http://insidescoopsf.sfgate.com/wp-content/blogs.dir/732/files/cheap-eats-around-cal/cal-campus_0.jpg",
            subtitle: self.tabling_string(member),
            buttons:[
              {
                type:"web_url",
                url:"http://pbl.link/tabling",
                title:"View full tabling schedule"
              }            
            ]
          },
          {
            title:"Events",
            image_url:"http://www.fairviewparkschools.org/wp-content/uploads/2015/06/calendar.png",
            subtitle: 'There are 4 events happening this week',
            buttons: self.event_buttons
          },
          {
            title:"Points",
            subtitle: self.points_string(member),
            buttons:[
              {
                type:"web_url",
                url:"http://pbl.link/points",
                title:"Attendance"
              },
              {
                type:"web_url",
                url:"http://pbl.link/scoreboard",
                title:"Scoreboard"
              },
              {
                type:"web_url",
                url:"http://pbl.link/distribution",
                title:"Distribution"
              }         
            ]
          }
        ]
      }
    }
  }
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

  def self.get_response(member, text)
    text = text.downcase
    splits = text.split(' ')
    puts 'getting response'
    begin
        case splits[0]
        when 'help'
          return self.get_generic_message(member)
          # return {:text=> 'Here are some commands you can use: "go KEY" for PBL Links, "tabling" for your schedule, "blog" for recent posts, "points", and "events" for the calendar. You can also type anything in here and I will search the wiki for you :)'}
        when 'whoami'
          return {:text => member.name.to_s}
        when 'ask'
          return {:text => 'I will find out the answer and let you know!'}
        when 'generate'
          TablingManager.gen_tabling
          return {:text => 'You generated tabling, check it out at http://pbl.link/tabling'}
        when 'points'
          return {:text=> self.points_string(member)}
        when 'tabling'
          return self.handle_tabling(member, text)
        when 'go'
          return self.handle_go(member, text)
        when 'blog'
          return self.handle_blog(member)
        when 'events', 'c', 'calendar', 'cal'
          buttons << {
            type: 'web_url',
            url: 'http://pbl.link/calendar',
            title: 'pbl.link/calendar'
          }
          return self.get_button_msg('Here is a link to the calendar', buttons)
        end

        if Member.committees.include?(text.upcase)
          names = Member.get_group(text).pluck(:name).join(', ')
          return {:text=>names}
        end
        return self.default_btns(text)
    rescue => error
      # return {:text => 'error'}
    end
  end
end
