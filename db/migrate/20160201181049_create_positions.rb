class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
    	t.string :member_email
    	t.string :semester
    	t.string :position
    	t.string :committee
      t.timestamps null: false
    end
  end
end
