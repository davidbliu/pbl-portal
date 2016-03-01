class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
    	t.string :name
    	t.text :emails
    	t.datetime :time
    	t.string :semester
    	t.text :description
    	t.text :links
    	t.text :images
      t.timestamps null: false
    end
  end
end
