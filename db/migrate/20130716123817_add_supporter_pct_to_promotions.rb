class AddSupporterPctToPromotions < ActiveRecord::Migration
  def change
  	    add_column :promotions, :supporter_pct, :integer
  end
end
