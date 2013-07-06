class FixColumnNameOnChannel < ActiveRecord::Migration
  	def up
  		rename_column :channels, :awesm, :awesm_id
	end

  	def down
  	end
end
