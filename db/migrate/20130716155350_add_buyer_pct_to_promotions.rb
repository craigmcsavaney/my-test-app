class AddBuyerPctToPromotions < ActiveRecord::Migration
  	def change
  	    add_column :promotions, :buyer_pct, :integer
  	end
end
