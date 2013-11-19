class AddButtonLocationIdToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :button_location_id, :integer
  end
end
