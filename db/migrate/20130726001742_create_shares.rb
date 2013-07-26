class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
  		t.references :serve,    :null => false
  		t.references :channel,    :null => false
  		t.string :link_id,		:null => false
  		t.boolean :confirmed
      t.boolean :deleted

      	t.timestamps
    end

   add_index :shares, :link_id,                :unique => true
  end
end
