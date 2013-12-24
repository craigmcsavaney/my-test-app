class RemoveChoosersEmailFromDonation < ActiveRecord::Migration
  def up
	remove_column :donations, :choosers_email
  end
end
