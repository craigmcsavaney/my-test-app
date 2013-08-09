class FixColumnNameOnPromotion < ActiveRecord::Migration
  def change
    rename_column :promotions, :p_banner_1, :banner
  end
end
