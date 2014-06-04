class ModifyTitleOnPromotions < ActiveRecord::Migration
  def up
    change_column :promotions, :title, :string, null: false
  end
end
