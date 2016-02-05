class AddSemesterToGoLinks < ActiveRecord::Migration
  def change
  	add_column :go_links, :semester, :string
  end
end
