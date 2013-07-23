class AddDisabledToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :disabled, :boolean
  end
end
