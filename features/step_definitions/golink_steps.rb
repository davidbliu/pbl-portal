
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

Given(/^I (.*) the box for "([^"]*)"$/) do |type, key|
	golink = GoLink.where(key: key).first
	if type == 'check'
		check("#{golink.id}-checkbox")
	else
		uncheck("#{golink.id}-checkbox")
	end
end

Given(/^I visit the checked links page$/) do 
	visit '/go/checked_links'
end

Given(/^I wait (\d+) seconds for sign in$/) do |arg1|
	sleep(arg1.to_i)
end

Given(/^I check the box to "([^"]*)" "([^"]*)"$/) do |type, groupKey|
	group = Group.where(key:groupKey).first
	check("#{type}-group-#{group.id}-checkbox")
end

Given(/^I click the id "([^"]*)"$/) do |id|
	find('#'+id).click
end

