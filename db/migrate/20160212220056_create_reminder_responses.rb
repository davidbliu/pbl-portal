class CreateReminderResponses < ActiveRecord::Migration
  def change
    create_table :reminder_responses do |t|
    	t.integer :reminder_id
    	t.string :member_email
    	t.string :response
    	t.string :other_content
      t.timestamps null: false
    end
  end
end
