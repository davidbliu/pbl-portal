class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
    	t.string :title
    	t.string :key
    	t.string :report_type
    	t.text :data_bins
    	t.text :data_labels
      t.timestamps null: false
    end
  end
end
