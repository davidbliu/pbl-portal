class CreateGoLinkTags < ActiveRecord::Migration
  def change
    create_table :go_link_tags do |t|
    	t.integer :golink_id
    	t.string :tag_name
      t.timestamps null: false
    end
  end
end
