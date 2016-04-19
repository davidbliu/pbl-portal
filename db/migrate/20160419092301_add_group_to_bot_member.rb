class AddGroupToBotMember < ActiveRecord::Migration
  def change
  	add_column :bot_members, :group, :integer
  end
end
