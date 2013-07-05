class AddIndexToMerchantsName < ActiveRecord::Migration
  def change
  	add_index :merchants, :name, unique: true
  end
end
