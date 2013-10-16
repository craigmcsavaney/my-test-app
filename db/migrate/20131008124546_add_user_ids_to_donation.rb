class AddUserIdsToDonation < ActiveRecord::Migration
  def change
    add_column :donations, :chooser_id, :integer
    add_column :donations, :supporter_id, :integer
    add_column :donations, :buyer_id, :integer
  end
end
