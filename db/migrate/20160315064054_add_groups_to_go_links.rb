class AddGroupsToGoLinks < ActiveRecord::Migration
  def change
  	add_column :go_links, :groups, :text
  end
end
