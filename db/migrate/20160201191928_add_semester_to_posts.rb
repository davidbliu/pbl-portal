class AddSemesterToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :semester, :string
  end
end
