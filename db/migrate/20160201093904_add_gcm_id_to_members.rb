class AddGcmIdToMembers < ActiveRecord::Migration
  def change
  	add_column :members, :gcm_id, :string
  end
end
