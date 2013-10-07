class AddUserIdToServe < ActiveRecord::Migration
  def change
    add_column :serves, :user_id, :integer
  end
end
