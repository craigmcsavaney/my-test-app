class AddBuyerShareIdToSale < ActiveRecord::Migration
  def change
    add_column :sales, :buyer_share_id, :integer
  end
end
