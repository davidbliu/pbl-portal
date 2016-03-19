class AddLandingPreference < ActiveRecord::Migration
  def change
    add_column :go_preferences, :landing_group_id, :integer
  end
end
