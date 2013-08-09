class AddUidIndexToMerchant < ActiveRecord::Migration
  def change
  	add_index :merchants, :uid, unique: true
  end
end
