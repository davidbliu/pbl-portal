class CreateMembers  < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :committee
      t.string :position
      t.string :major
      t.string :year
      t.string :latest_semester
      t.string :role
      t.text :commitments

      t.timestamps
    end

  end
end
