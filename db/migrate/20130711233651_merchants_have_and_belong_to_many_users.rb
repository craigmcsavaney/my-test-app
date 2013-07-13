class MerchantsHaveAndBelongToManyUsers < ActiveRecord::Migration
  	def up
	  	create_table :merchants_users, :id => false do |t|
	      t.references :merchant, :user
		end
    	add_index :merchants_users, [:user_id, :merchant_id], unique: true
	end

  	def down
  		drop_table :merchants_users
  	end
end
