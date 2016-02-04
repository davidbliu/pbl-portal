class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
    	t.string :item_type
    	t.string :title
    	t.string :body
    	t.datetime :timestamp
    	t.string :link
    	t.string :status
    	t.text :recipients
      t.timestamps null: false
    end
  end
end
