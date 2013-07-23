class AddCauseIdToPromotions < ActiveRecord::Migration
  def change
  	    add_column :promotions, :cause_id, :integer
  end
end
