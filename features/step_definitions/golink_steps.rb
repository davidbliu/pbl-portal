Given(/^the following golinks exist:$/) do |table|
  # table is a Cucumber::Core::Ast::DataTable
  table.hashes.each do |golink|
  	GoLink.create(
  		key: golink[:key],
  		url: golink[:url],
  		groups: golink[:groups])
  end
end