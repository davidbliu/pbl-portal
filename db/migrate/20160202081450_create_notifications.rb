class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
    	t.string :type
    	t.datetime :timestamp
    	t.string :dst
    	t.string :src
    	t.text :content
      t.timestamps null: false
    end
  end
end
