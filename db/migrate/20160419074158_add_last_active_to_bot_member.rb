class AddLastActiveToBotMember < ActiveRecord::Migration
  def change
  	add_column :bot_members, :last_active, :datetime
  end
end
