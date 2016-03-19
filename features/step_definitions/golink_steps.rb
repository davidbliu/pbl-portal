
Given(/^the following golinks exist:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  table.hashes.each do |golink|
  	GoLink.create(
  		key: golink[:key],
  		url: golink[:url],
  		groups: golink[:groups])
  end
end

Given(/^I am batch editing "([^"]*)"$/) do |keys|
	ids = GoLink.where('key in (?)', keys.split(',').map{|x| x.strip}).pluck(:id)
	visit '/go/batch_edit?ids='+ids.to_json.to_s
end

Given(/^I check the box for "([^"]*)"$/) do |key|
	golink = GoLink.where(key: key).first
	# puts GoLink.all.map{|x| x.id.to_s+':'+x.key}
	# id = golink.id.to_s+'-checkbox'
	# puts page.first('.golink-checkbox')[:id]
	# find('#'+golink.id.to_s+'-checkbox').click
	# find('#check-check').click
	check('check-check')
end

Given(/^I visit the checked links page$/) do 
	visit '/go/checked_links'
end

