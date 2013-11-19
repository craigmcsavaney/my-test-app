class AddButtonLocationIdToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :button_location_id, :integer
  end
end
