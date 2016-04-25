class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.references :bot_member
      t.string :sender
      t.timestamps null: false
    end
  end
end
