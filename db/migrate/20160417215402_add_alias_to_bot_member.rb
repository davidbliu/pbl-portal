class AddAliasToBotMember < ActiveRecord::Migration
  def change
  	add_column :bot_members, :alias, :string
  	add_column :bot_members, :name, :string
  end
end
