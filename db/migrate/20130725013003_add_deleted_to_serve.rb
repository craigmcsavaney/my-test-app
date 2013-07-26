class AddDeletedToServe < ActiveRecord::Migration
  def change
    add_column :serves, :deleted, :boolean
  end
end
