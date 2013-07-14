class CausesHaveAndBelongToManyUsers < ActiveRecord::Migration
  	def up
	  	create_table :causes_users, :id => false do |t|
	      t.references :cause, :user
		end
    	add_index :causes_users, [:user_id, :cause_id], unique: true
	end

  	def down
  		drop_table :causes_users
  	end
end
