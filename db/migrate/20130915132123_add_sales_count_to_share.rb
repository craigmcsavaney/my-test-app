class AddSalesCountToShare < ActiveRecord::Migration
  def self.up
    add_column :shares, :sales_count, :integer, :default => 0

    Share.reset_column_information
    Share.find(:all).each do |s|
    	s.update_attribute :sales_count, s.sales.length
    end
  end

  def self.down
  	remove_column :shares, :sales_count
  end
end
