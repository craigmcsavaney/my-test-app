class AddDeletedToType < ActiveRecord::Migration
  def change
    add_column :types, :deleted, :boolean
  end
end
