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