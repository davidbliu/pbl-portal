maxint = 1000000
namespace :parse do
  task :golinks => :environment do 
    GoLink.destroy_all
    parseGolinks = ParseGoLink.limit(maxint).all
    parseGolinks.each do |pgl|
      golink = GoLink.create(
        key: pgl.key,
        url: pgl.url,
        description: pgl.description,
        member_email: pgl.member_email,
        num_clicks: pgl.num_clicks,
        timestamp: pgl.createdAt,
        created_at: pgl.createdAt,
        title: pgl.title,
        permissions: pgl.permissions,
        semester: 'Fall 2015'
      )
      puts pgl.key
    end
    puts ParseMember.limit(maxint).length
    puts 'hi there'
  end

  task :members => :environment do
    Member.destroy_all
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
        latest_semester: pm.latest_semester,
        created_at: pm.createdAt
      )
    end

    Position.where(semester: 'Fall 2015').destroy_all
    Member.where(latest_semester: 'Fall 2015').each do |m|
      Position.create(
        semester: 'Fall 2015',
        member_email: m.email,
        position: m.position,
        committee: m.committee
      )
    end
    Member.sp16_import
  end

  task :blog => :environment do
    Post.all.destroy_all
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
        timestamp: bp.createdAt,
        tags: bp.tags,
        created_at: bp.createdAt
      )
    end
    Post.all.each do |post|
      post.semester = 'Fall 2015'
      post.save
    end
  end

end

namespace :cleanup do 
  task :feed => :environment do 
    FeedItem.destroy_all
    FeedItemResponse.destroy_all
  end
end

