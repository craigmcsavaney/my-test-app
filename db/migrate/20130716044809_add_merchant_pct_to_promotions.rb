class AddMerchantPctToPromotions < ActiveRecord::Migration
  def change
  	    add_column :promotions, :merchant_pct, :integer
  end
end
