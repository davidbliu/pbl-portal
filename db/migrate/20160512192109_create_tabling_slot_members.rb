class CreateTablingSlotMembers < ActiveRecord::Migration
  def change
    create_table :tabling_slot_members do |t|
    	t.string :email
    	t.references :tabling_slot
      t.timestamps null: false
    end
  end
end
