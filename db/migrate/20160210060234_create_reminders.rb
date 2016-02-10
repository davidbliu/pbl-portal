class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
    	t.string :title
    	t.string :link
    	t.string :body
    	t.string :member_email
    	t.string :author
    	t.string :reminder_id
      t.timestamps null: false
    end
  end
end
