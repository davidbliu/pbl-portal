class AddIsActiveToMembers < ActiveRecord::Migration
  def change
  	add_column :members, :is_active, :boolean, null: false, default: false
  	drop_table :tabling_slot_members
  end
end
