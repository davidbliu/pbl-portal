class AddParticipatingToBotMembers < ActiveRecord::Migration
  def change
    add_column :bot_members, :participating, :boolean, default: false
  end
end
