class AddLogoLinkToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :logo_link, :string
  end
end
