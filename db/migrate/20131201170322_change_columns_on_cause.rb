class ChangeColumnsOnCause < ActiveRecord::Migration
  	change_column :causes, :name, :string, null: false
  	change_column :causes, :uid, :string, null: false
  	change_column :causes, :type, :string, null: false
  	remove_index :causes, name: "index_causes_on_name"
  	add_index :causes, :name, unique: true

end
