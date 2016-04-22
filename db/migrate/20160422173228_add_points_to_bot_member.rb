class AddPointsToBotMember < ActiveRecord::Migration
  def change
    add_column :bot_members, :points, :integer
  end
end
