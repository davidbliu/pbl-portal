class AddPartnerToBotMember < ActiveRecord::Migration
  def change
  	add_column :bot_members, :partner, :string
  end
end
