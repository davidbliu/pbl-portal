class CreatePostGroups < ActiveRecord::Migration
  def change
    create_table :post_groups do |t|
    	t.references :post
    	t.references :group
      t.timestamps null: false
    end
  end
end
