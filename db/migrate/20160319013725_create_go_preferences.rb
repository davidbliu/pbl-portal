class CreateGoPreferences < ActiveRecord::Migration
  def change
    create_table :go_preferences do |t|
      t.string :email
      t.text :default_group_ids
      t.text :search_group_ids
      t.timestamps null: false
    end
  end
end
