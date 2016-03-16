World(ShowMeTheCookies)
Given(/^that I am logged in as "([^"]*)"$/) do |email|
	create_cookie('email', email)
end