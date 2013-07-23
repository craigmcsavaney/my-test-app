class AddDeletedToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :deleted, :boolean
  end
end
