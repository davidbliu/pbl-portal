require 'csv'
task :export_pts => :environment do
  CSV.open('sp16_points.csv', 'w') do |writer|
    writer << ['name', 'points', 'committee']
    Member.where(latest_semester:'Spring 2016').order('committee asc').each do |m|
      writer << [m.name, Event.get_score(m.email), m.committee]
    end
  end
end

task :export_members => :environment do
  CSV.open('sp16_members.csv', 'w') do |writer|
    writer << ['name', 'email', 'committee', 'major']
    Member.where(latest_semester:'Spring 2016').order('committee asc').each do |m|
      writer << [m.name, m.email, m.committee, m.major]
    end
  end
end

task :export_clicks => :environment do
  CSV.open('sp16_clicks.csv', 'w')  do |writer|
    writer << ['key', 'email', 'committee', 'position', 'timestamp', 'hour', 'month', 'day', 'year']
    len = GoLinkClick.all.length
    i = 0
    GoLinkClick.order('created_at desc').where('member_email != ?', 'davidbliu@gmail.com').each do |click|
      puts "#{i} of #{len}"
      i+=1
      member = Member.find_by_email(click.member_email)
      time = click.created_at.in_time_zone("Pacific Time (US & Canada)")
      if not member.nil?
        writer << [click.key, click.member_email, member.committee,member.position, time, time.hour, time.month, time.day, time.year]
      else
        writer << [click.key, click.member_email, nil, nil, time, time.hour, time.month, time.day, time.year]
      end
    end
    
  end
end

task :export_links => :environment do 
  CSV.open('sp16_links.csv', 'w') do |writer|
    writer << ['key', 'url', 'created_at', 'month,day,year,hour', 'num_clicks']
    GoLink.order('created_at desc').all.each do |golink|
      time = golink.created_at.in_time_zone("Pacific Time (US & Canada)")
      tstring = "#{time.month},#{time.day},#{time.year},#{time.hour}"
      num_clicks = GoLinkClick.where(key: golink.key).where.not(member_email:'davidbliu@gmail.com').length
      writer << [golink.key, golink.url, time, tstring, num_clicks]
    end
  end
end

task :export_attendance => :environment do 
  CSV.open('sp16_attendance.csv', 'w') do |writer|
    writer << ['event_name', 'attendee', 'committee','year', 'month', 'day']
    Event.all.each do |e|
      e.get_attended.each do |a|
        m = Member.find_by_email(a)
        if m.nil?
          c = nil
        else
          c = m.committee
        end
        writer << [e.name, a, c, e.time.year, e.time.month, e.time.day]
      end
    end
  end
end

task :export_posts => :environment do 
  CSV.open('sp16_posts.csv', 'w') do |writer|
    writer << ['post_title', 'author', 'author_committee', 'num_views', 'year', 'month', 'day']
    Post.order('created_at desc').where(semester:'Spring 2016').each do |p|
      m = Member.find_by_email(p.author)
      c = nil
      t = p.created_at.in_time_zone("Pacific Time (US & Canada)")
      if not m.nil?
        c = m.committee
      end
      num_clicks = GoLinkClick.where('key LIKE ?', "%/blog/post/#{p.id}%").length
      writer << [p.title, p.author, c, num_clicks, t.year, t.month, t.day]
    end
  end
end
