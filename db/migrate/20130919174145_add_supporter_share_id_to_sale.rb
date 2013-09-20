class AddSupporterShareIdToSale < ActiveRecord::Migration
  def change
    add_column :sales, :supporter_share_id, :integer
  end
end
