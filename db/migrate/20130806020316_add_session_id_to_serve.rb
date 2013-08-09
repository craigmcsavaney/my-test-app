class AddSessionIdToServe < ActiveRecord::Migration
  def change
    add_column :serves, :session_id, :string
  end
end
