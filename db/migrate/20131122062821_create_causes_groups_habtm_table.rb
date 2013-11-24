class CreateCausesGroupsHabtmTable < ActiveRecord::Migration
  	def up
	  	create_table :causes_groups, :id => false do |t|
	      t.references :cause, :group
		end
    	add_index :causes_groups, [:cause_id, :group_id], unique: true
	end

  	def down
  		drop_table :causes_groups
  	end
end
