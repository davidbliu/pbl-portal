class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|

      t.timestamps null: false
      t.text :body
      t.integer :count
    end
  end
end
