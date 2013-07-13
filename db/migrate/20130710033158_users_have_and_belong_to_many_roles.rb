class UsersHaveAndBelongToManyRoles < ActiveRecord::Migration
  	def up
	  	create_table :roles_users, :id => false do |t|
	      t.references :role, :user
		end
    	add_index :roles_users, [:user_id, :role_id], unique: true
	end

  	def down
  		drop_table :roles_users
  	end
end
