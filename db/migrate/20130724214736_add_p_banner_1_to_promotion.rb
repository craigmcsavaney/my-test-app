class AddPBanner1ToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :p_banner_1, :string
  end
end
