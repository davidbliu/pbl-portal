task :group_migrate => :environment do 
	GroupMember.all.each do |gm|
		puts "group was #{gm.group}"
		gp = Group.find_by_key(gm.group)
		if gp.nil?
		else
			gm.update!(group_id: gp.id)
		end
	end
end