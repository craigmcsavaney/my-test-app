class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
    	t.string :name, default: ""
    	t.string :description, default: ""
    	t.string :type, null: false
    	t.integer :order, default: 0
    	t.boolean :deleted, default: false

      	t.timestamps
    end
  end
end
