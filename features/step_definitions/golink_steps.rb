
Given(/^the following golinks exist:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  table.hashes.each do |golink|
  	GoLink.create(
  		key: golink[:key],
  		url: golink[:url],
  		groups: golink[:groups])
  end
end


Given(/^the following preferences exist:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  table.hashes.each do |row|
  	row[:default] ||= ''
  	row[:landing] ||= nil
  	GoPreference.create(
  		email: row[:key],
  		default_group_ids: row[:default].split(','),
  		landing_group_id: row[:landing])
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

Given(/^I delete checked links$/) do
	visit '/go/delete_checked'
end

Given(/^I check the default box for "(.*)"$/) do |group_key|
	group = Group.where(key: group_key).first
	check("#{group.id}-default")
end

Given(/^I add a link: "(.*)" "(.*)"$/) do |key, url|
	visit "/go/add?key=#{key}&url=#{url}"
end

Given(/^I save my preferences$/) do
	find('#save-preferences-btn').click
end

Given(/^I restore "(.*)"$/) do |key|
	copy = GoLinkCopy.where(key: key).last
	click_link(copy.id.to_s+'-restore-link')
end

Given(/^I destroy the copy of "(.*)"$/) do |key|
	copy = GoLinkCopy.where(key: key).last
	click_link(copy.id.to_s+'-destroy-link')
end

Given(/I select "(.*)" as my landing page$/) do |key|
	group = Group.where(key: key).first
	find("option[value='"+group.id.to_s+"-landing']").click
end

Given(/I should be on the trash page$/) do
	assert page.current_path == go_trash_path
end

