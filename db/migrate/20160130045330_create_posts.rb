class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
    	t.string :title
    	t.string :author
    	t.string :edit_permissions
    	t.string :view_permissions
    	t.string :folder
    	t.text :content
    	t.datetime :timestamp
    	t.timestamps

    end
  end
end
