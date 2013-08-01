class AddPromotionsCountToMerchant < ActiveRecord::Migration
  def self.up
    add_column :merchants, :promotions_count, :integer, :default => 0

    Merchant.find(:all).each do |m|
    	m.update_attribute :promotions_count, m.promotions.length
    end
  end

  def self.down
  	remove_column :merchants, :promotions_count
  end
end
