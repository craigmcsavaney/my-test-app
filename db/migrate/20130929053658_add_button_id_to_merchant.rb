class AddButtonIdToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :button_id, :integer
  end
end
