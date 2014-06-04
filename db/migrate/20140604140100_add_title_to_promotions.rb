class AddTitleToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :title, :string
  end
end
