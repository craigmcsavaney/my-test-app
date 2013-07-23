class AddPriorityToPromotion < ActiveRecord::Migration
  def change
  	    add_column :promotions, :priority, :integer
  end
end
