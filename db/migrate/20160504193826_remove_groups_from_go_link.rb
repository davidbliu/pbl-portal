class RemoveGroupsFromGoLink < ActiveRecord::Migration
  def change
    remove_column :go_links, :groups
    remove_column :go_link_copies, :groups
  end
end
