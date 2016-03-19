World(ShowMeTheCookies)
Given(/^I am logged in as "([^"]*)"$/) do |email|
	create_cookie('email', email)
end

Given(/^I log in as "(.*)"$/) do |email|
	visit "/cookie_hack?email=#{email}"
end