class AddIndexToServesSessionId < ActiveRecord::Migration
  def change
  	add_index :serves, :session_id, unique: true
  end
end
