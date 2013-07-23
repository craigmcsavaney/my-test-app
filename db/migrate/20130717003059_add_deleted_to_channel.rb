class AddDeletedToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :deleted, :boolean
  end
end
