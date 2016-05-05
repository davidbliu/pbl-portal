class AddIsOpenToGroup < ActiveRecord::Migration
  def change
  	add_column :groups, :is_open, :boolean
  end
end
