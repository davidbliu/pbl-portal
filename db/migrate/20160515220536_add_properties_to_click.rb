class AddPropertiesToClick < ActiveRecord::Migration
  def change
  	add_column :clicks, :properties, :text
  	add_column :clicks, :name, :string
  end
end
