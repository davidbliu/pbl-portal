class AddPermissionsToFeedItem < ActiveRecord::Migration
  def change
  	add_column :feed_items, :permissions, :string
  	add_column :feed_items, :member_email, :string
  end
end
