class CreateGoLinks < ActiveRecord::Migration
  def change
    create_table :go_links do |t|
      t.string :key
      t.string :url
      t.string :member_email
      t.string :description
      t.string :title
      t.integer :num_clicks
      t.datetime :timestamp

      t.timestamps null: false
    end
  end
end
