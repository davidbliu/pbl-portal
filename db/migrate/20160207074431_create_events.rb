class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
    	t.string :name
    	t.string :semester
    	t.datetime :time
    	t.integer :points
      t.timestamps null: false
    end
  end
end
