class ChangeButtonIdOnPromotion < ActiveRecord::Migration
  def up
  	change_column :promotions, :button_id, :integer, null: false
  end
end
