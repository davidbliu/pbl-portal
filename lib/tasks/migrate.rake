maxint = 1000000

namespace :parse do
  task :golinks => :environment do 
    parseGolinks = ParseGoLink.limit(maxint).all
    parseGolinks.each do |pgl|
      golink = GoLink.create(
        key: pgl.key,
        url: pgl.url,
        description: pgl.description,
        member_email: pgl.member_email,
        num_clicks: pgl.num_clicks,
        timestamp: pgl.createdAt
      )
      puts pgl.key
    end
    puts ParseMember.limit(maxint).length
    puts 'hi there'
  end

  task :members => :environment do
    parseMembers = ParseMember.limit(maxint).all
    puts parseMembers.length.to_s + ' members pulled from parse'
    parseMembers.each do |pm|
      puts pm.email
      Member.create(
        name: pm.name,
        email: pm.email,
        phone: pm.phone,
        position: pm.position,
        committee: pm.committee,
        role: pm.role,
        commitments: pm.commitments,
        latest_semester: pm.latest_semester
      )
    end
  end
end
