class CreateFeedResponses < ActiveRecord::Migration
  def change
    create_table :feed_responses do |t|
    	t.integer :feed_item_id
    	t.string :member_email
    	t.string :response_type
    end
  end
end
