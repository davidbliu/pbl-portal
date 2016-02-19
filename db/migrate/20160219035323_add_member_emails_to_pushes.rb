class AddMemberEmailsToPushes < ActiveRecord::Migration
  def change
  	add_column :pushes, :member_emails, :text
  end
end
