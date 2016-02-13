class AddInputToReminder < ActiveRecord::Migration
  def change
  	add_column :reminders, :reminder_type, :string
  end
end
