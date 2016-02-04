class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
    	t.string :notification_type
    	t.integer :object_id
    	t.datetime :timestamp
    	t.text :channels
    	t.string :sender
    	t.text :content
      t.timestamps null: false
    end
  end
end
