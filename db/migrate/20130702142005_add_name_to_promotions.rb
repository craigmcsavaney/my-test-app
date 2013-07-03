class AddNameToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :name, :string
  end
end
