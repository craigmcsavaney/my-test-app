class CreateButtons < ActiveRecord::Migration
  def change
    create_table :buttons do |t|
    	t.string :name, default: ""
    	t.string :description, default: ""
    	t.references :button_type, null: false
    	t.integer :display_order, null: false, default: 0
    	t.string :filename, default: ""
    	t.boolean :deleted, default: false

      t.timestamps
    end
  end
end