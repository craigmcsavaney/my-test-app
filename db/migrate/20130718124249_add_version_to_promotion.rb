class AddVersionToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :uid, :decimal, precision: 16, scale: 6
  end
end
