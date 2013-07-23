class CreateServes < ActiveRecord::Migration
  def change
    create_table :serves do |t|
  		t.references :promotion,    :null => false

      t.timestamps
    end
  end
end
