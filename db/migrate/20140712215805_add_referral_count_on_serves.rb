class AddReferralCountOnServes < ActiveRecord::Migration
  def self.up
    add_column :serves, :referral_count, :integer, :default => 0

    Serve.all.each do |serve|
    	a = 0
    	serve.shares.load.each do |share|
    		a = a + share.serves.length
    	end
   		serve.update_attribute(:referral_count, a)

    end

     change_column :serves, :referral_count, :integer, :default => 0, null: false

  end

  def self.down
  	remove_column :serves, :referral_count
  end
end
