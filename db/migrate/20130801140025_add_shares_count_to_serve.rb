class AddSharesCountToServe < ActiveRecord::Migration
  def self.up
    add_column :serves, :shares_count, :integer, :default => 0

    Serve.reset_column_information
    Serve.find(:all).each do |s|
    	s.update_attribute :shares_count, s.shares.length
    end
  end

  def self.down
  	remove_column :serves, :shares_count
  end
end
