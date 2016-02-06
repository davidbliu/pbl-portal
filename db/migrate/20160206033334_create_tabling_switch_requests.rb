class CreateTablingSwitchRequests < ActiveRecord::Migration
  def change
    create_table :tabling_switch_requests do |t|
    	t.string :email1
    	t.string :email2
    	t.string :switch_status
      t.timestamps null: false
    end
  end
end
