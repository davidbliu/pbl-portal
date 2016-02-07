class CreateFeedPushes < ActiveRecord::Migration
  def change
    create_table :feed_pushes do |t|
    	t.integer :feed_item_id
    	t.text :response
    	t.string :member_email
      t.timestamps null: false
    end
  end
end
