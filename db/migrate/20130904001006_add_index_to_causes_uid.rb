class AddIndexToCausesUid < ActiveRecord::Migration
  def change
  	add_index :causes, :uid, unique: true
  end
end
