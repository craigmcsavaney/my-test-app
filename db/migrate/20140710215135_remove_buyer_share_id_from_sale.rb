class RemoveBuyerShareIdFromSale < ActiveRecord::Migration
  def up
    remove_column :sales, :buyer_share_id
  end

  def down
    add_column :sales, :buyer_share_id, :integer
  end
end
