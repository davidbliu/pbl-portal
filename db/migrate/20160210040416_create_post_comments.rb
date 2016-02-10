class CreatePostComments < ActiveRecord::Migration
  def change
    create_table :post_comments do |t|
    	t.integer :post_id
    	t.string :member_email
    	t.text :content
      t.timestamps null: false
    end

    add_column :posts, :num_comments, :integer
    add_column :posts, :link, :string
  end
end
