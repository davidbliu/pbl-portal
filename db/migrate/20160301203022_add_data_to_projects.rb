class AddDataToProjects < ActiveRecord::Migration
  def change
  	# add_column :projects, :xfields, :text
  	# add_column :profiles, :xfields, :text
  	add_column :projects, :members, :text
  	add_column :projects, :embed, :text
  	add_column :profiles, :major, :string
  	add_column :profiles, :website, :string
  end
end
