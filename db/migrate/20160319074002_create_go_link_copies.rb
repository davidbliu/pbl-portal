class CreateGoLinkCopies < ActiveRecord::Migration
  def change
    create_table :go_link_copies do |t|
      t.string :key
      t.string :member_email
      t.string :groups
      t.string :description
      t.string :url
      t.integer :golink_id

      t.timestamps null: false
    end
  end
end
