class CreateButtonTypes < ActiveRecord::Migration
  def change
    create_table :button_types do |t|
    	t.string :name, null: false
    	t.string :description, default: ""
    	t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
