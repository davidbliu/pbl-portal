class CreateGoTags < ActiveRecord::Migration
  def change
    create_table :go_tags do |t|
    	t.string :name
    	t.string :description
    	t.string :creator
      t.timestamps null: false
    end
  end
end
