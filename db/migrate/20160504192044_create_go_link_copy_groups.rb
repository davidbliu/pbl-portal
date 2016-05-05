class CreateGoLinkCopyGroups < ActiveRecord::Migration
  def change
    create_table :go_link_copy_groups do |t|
      t.references :go_link_copy
      t.references :group

      t.timestamps null: false
    end
  end
end
