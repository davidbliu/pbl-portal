class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
    	t.string :path
    	t.text :params
    	t.string :email
      t.timestamps null: false
    end
  end
end
