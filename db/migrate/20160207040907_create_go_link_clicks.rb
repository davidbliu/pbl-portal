class CreateGoLinkClicks < ActiveRecord::Migration
  def change
    create_table :go_link_clicks do |t|
    	t.string :member_email
    	t.string :key
    	t.string :golink_id
      t.timestamps null: false
    end
  end
end
