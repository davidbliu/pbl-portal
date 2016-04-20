class AddLastGroupIdToBotMembers < ActiveRecord::Migration
  def change
  	add_column :bot_members, :last_group_id, :integer
  end
end
