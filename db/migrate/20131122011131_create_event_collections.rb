class CreateEventCollections < ActiveRecord::Migration
  def change
    create_table :event_collections do |t|
    	t.string :name, default: ""
    	t.string :description, default: ""
    	t.integer :order, default: 0
    	t.boolean :deleted, default: false
      	t.date :event_date, null: false, default: Time.now
      	t.date :start_date, null: false, default: Time.now
      	t.date :end_date, null: false, default: Time.now

      	t.timestamps
    end
  end
end
