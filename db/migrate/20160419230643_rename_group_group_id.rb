class RenameGroupGroupId < ActiveRecord::Migration
  def change
  	rename_column :bot_members, :group, :group_id
  end
end
