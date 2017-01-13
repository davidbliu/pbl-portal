class AddBroadcastFieldsToBotMembers < ActiveRecord::Migration
  def change
    add_column :bot_members, :subscribed_to_announcements, :boolean, default: false
    add_column :bot_members, :subscribed_to_tabling, :boolean, default: false
  end
end
