class DropEmailFromServe < ActiveRecord::Migration
  def up
	remove_column :serves, :email
  end
end
