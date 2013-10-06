class ChangeButtonIdOnMerchant < ActiveRecord::Migration
  def up
  	change_column :merchants, :button_id, :integer
  end
end
