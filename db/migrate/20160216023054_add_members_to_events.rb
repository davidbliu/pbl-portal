class AddMembersToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :attended, :text
  	add_column :events, :unattended, :text
  end
end
