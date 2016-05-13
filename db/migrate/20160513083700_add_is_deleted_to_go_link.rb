class AddIsDeletedToGoLink < ActiveRecord::Migration
  def change
  	add_column :go_links, :is_deleted, :boolean, null: false, default: false
  	drop_table :go_link_copies
  	drop_table :go_link_copy_groups
  end
end
