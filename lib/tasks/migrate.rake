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
        timestamp: pgl.createdAt,
        title: pgl.title,
        permissions: pgl.permissions
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

  task :blog => :environment do
    blogPosts = BlogPost.limit(maxint).all
    puts blogPosts.map{|x| x.title}
    blogPosts.each do |bp|
      Post.create(
        title: bp.title,
        content: bp.content,
        author: bp.author,
        edit_permissions: bp.edit_permissions,
        view_permissions: bp.view_permissions,
        folder: bp.folder,
        timestamp: bp.createdAt
      )
    end
  end
end
