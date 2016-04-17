class CreateBotMembers < ActiveRecord::Migration
  def change
    create_table :bot_members do |t|
      t.string :sender_id
      t.string :email

      t.timestamps null: false
    end
  end
end
