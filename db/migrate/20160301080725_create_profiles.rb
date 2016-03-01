class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
    	t.string :email
    	t.string :grad
    	t.string :phone
    	t.text :positions
    	t.text :projects
    	t.text :jobs
    	t.text :extracurriculuars
    	t.text :awards
    	t.text :state_awards
    	t.text :case_comps
    	t.text :description
    	t.text :gallery
    	t.text :images
    	t.text :nicknames
    	t.string :hometown
      t.timestamps null: false
    end
  end
end
