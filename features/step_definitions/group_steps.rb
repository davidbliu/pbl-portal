Given(/^the following groups exist:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  table.hashes.each do |group|
  	Group.create(
  		key: group[:key],
  		name: group[:name])
  	group[:emails].split(',').map{|x| x.strip}.each do |email|
  		GroupMember.create(
  			group: group[:key],
  			email: email)
  	end
  end
end