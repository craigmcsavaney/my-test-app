class AddDeletedToRole < ActiveRecord::Migration
  def change
    add_column :roles, :deleted, :boolean
  end
end
