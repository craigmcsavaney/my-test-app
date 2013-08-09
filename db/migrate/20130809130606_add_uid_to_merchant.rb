class AddUidToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :uid, :string
  end
end
