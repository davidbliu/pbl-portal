class CreateTablingSlots < ActiveRecord::Migration
  def change
    create_table :tabling_slots do |t|
    	t.integer :time
    	t.text :member_emails
      t.timestamps null: false
    end
  end
end
