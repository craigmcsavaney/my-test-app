class AddLandingPageToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :landing_page, :string
  end
end
