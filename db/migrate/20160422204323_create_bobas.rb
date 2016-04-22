class CreateBobas < ActiveRecord::Migration
  def change
    create_table :bobas do |t|
      t.string :name
      t.integer :sender_id
      t.string :order
      t.string :address


      t.timestamps null: false
    end
  end
end
