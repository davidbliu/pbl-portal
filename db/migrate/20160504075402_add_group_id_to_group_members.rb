class AddGroupIdToGroupMembers < ActiveRecord::Migration
  def change
    add_column :group_members, :group_id, :integer
  end
end
