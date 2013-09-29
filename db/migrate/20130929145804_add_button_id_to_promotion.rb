class AddButtonIdToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :button_id, :integer
  end
end
