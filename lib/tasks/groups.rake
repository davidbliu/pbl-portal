task :import_blog => :environment do
	require "yaml"
	posts = YAML::load(File.open('posts_dump.yaml'))
	posts.each do |post|
		# puts post["email"]
		# puts post["title"]
		# puts Time.strptime("%Y-%m-%d", post["date"])
		# puts post["date"].month
		Post.create(
			view_permissions:'old',
			title: post["title"],
			author: post["email"],
			content: post["body"],
			created_at: post["date"])
	end
end
task :load_groups => :environment do
	data = Marshal.load(File.binread('go_groups.marshal'))
	GroupMember.where(group_id: nil).destroy_all
	data[:group_members].each do |gm|
		Group.find(gm[:group_id]).group_members.create(email: gm[:email])
	end
	data[:golinks].each do |gl|
		GoLink.find(gl[:id]).groups << Group.find(gl[:group_id])
	end
end

task :group_migrate => :environment do 
	group_members = []
	groups = []
	golinks = []
	GroupMember.all.each do |gm|
		group = Group.find_by_key(gm.group)
		if group.nil?
			puts 'nil group'
		else
			group_members << {
				email: gm.email,
				group_id: group.id
			}
		end
	end
	Group.all.each do |gp|
		groups << {
			name: gp.name ? gp.name : gp.key,
			creator: gp.creator,
			id: gp.id
		}
	end
	GoLink.all.each do |gl|
		gps = gl.groups.split(',')
		gps.each do |gp|
			gp = Group.find_by_key(gp)
			if not gp.nil?
				golinks << {
					id: gl.id,
					group_id: gp.id
				}
			end
		end
	end

	data = {
		group_members: group_members, 
		groups: groups,
		golinks: golinks
	}
	File.open('go_groups.marshal', 'wb'){
		|f| f.write(Marshal.dump(data))
	}
end