class Init < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :email
      t.text :commitments
      t.timestamps
    end
  end
end
