class AddServesCountToPromotion < ActiveRecord::Migration
  def self.up
    add_column :promotions, :serves_count, :integer, :default => 0

    Promotion.reset_column_information
    Promotion.find(:all).each do |p|
    	p.update_attribute :serves_count, p.serves.length
    end
  end

  def self.down
  	remove_column :promotions, :serves_count
  end
end