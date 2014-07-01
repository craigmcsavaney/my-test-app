class AddAutoButtonIdToMerchants < ActiveRecord::Migration
  def change
    add_column :merchants, :auto_button_id, :integer
  end
end
