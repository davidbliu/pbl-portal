class CreateGoLinkGroups < ActiveRecord::Migration
  def change
    create_table :go_link_groups do |t|
      t.references :group
      t.references :go_link
      t.timestamps null: false
    end
  end
end
