class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
    	t.string :title
    	t.string :link
    	t.string :body
      t.text :buttons
      t.text :reminder_status
    	t.string :author
      t.timestamps null: false
    end
  end
end
