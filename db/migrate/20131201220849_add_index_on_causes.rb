class AddIndexOnCauses < ActiveRecord::Migration
  	add_index :causes, :fg_uuid
end
