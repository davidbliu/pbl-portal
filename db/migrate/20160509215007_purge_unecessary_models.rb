class PurgeUnecessaryModels < ActiveRecord::Migration
  def change
  	drop_table :feed_items
  	drop_table :feed_pushes
  	drop_table :feed_responses
  	drop_table :go_link_tags
  	drop_table :go_preferences
  	drop_table :go_tags
  	drop_table :notifications
  	drop_table :profiles
  	drop_table :projects
  	drop_table :reminders
  	drop_table :reminder_responses
  	drop_table :reports
  end
end
