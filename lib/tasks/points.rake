task :export_points => :environment do
  Member.where(latest_semester:'Spring 2016').order('committee asc').each do |member|
    puts member.name+','+member.committee+','+Event.get_score(member.email).to_s
  end
end
task :pull_events => :environment do
  Event.pull_events
end

