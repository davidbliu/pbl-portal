class CreatePushes < ActiveRecord::Migration
  def change
    create_table :pushes do |t|
    	t.string :title
    	t.string :body
    	t.string :push_id
    	t.string :author
    	t.string :push_type
    	t.text :response
      t.timestamps null: false
    end
  end
end
