class AddDefaultGroupToMembers < ActiveRecord::Migration
  def change
  	add_column :members, :default_group, :string
  end
end
