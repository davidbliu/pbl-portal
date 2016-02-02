class AddLastEditorToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :last_editor, :string
  end
end
