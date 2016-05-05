Given(/^the following groups exist:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  table.hashes.each do |group|
  	gp = Group.create(
  		name: group[:name],
      creator: group[:creator])
  	group[:emails].split(',').map{|x| x.strip}.each do |email|
  		GroupMember.create(
  			group_id: gp.id,
  			email: email)
  	end
  end
end

Given(/^I delete the group "([^"]*)"$/) do |key|
  group = Group.where(key: key).first
  visit "groups/destroy/#{group.id}"
end

Given /I fill out group name with "(.*)"$/ do |name|
  fill_in "name", :with => name
end

Given /^I save the group$/ do 
  click_button "Submit"
end

Then /there should be "(.*)" groups$/ do |num|
  num=num.to_i
  expect(Group.all.length).to eq(num)
end

Given /I edit group "(.*)"$/ do |name|
  group = Group.find_by_name(name)
  visit "/groups/edit/#{group.id}"
end

Given /I make group "(.*)" open$/ do |name|
  Group.find_by_name(name).update(is_open: true)
end