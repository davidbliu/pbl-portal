class AddCreatorToGroup < ActiveRecord::Migration
  def change
  	add_column :groups, :creator, :string
  end
end
