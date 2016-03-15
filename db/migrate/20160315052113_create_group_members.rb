class CreateGroupMembers < ActiveRecord::Migration
  def change
    create_table :group_members do |t|
    	t.string :email
    	t.string :group
      t.timestamps null: false
    end

    remove_column :groups, :emails
    add_column :groups, :description, :text
    add_column :groups, :photo_url, :string

  end
end
