class AddColumnsToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :visible, :boolean, default: true
    add_column :channels, :active, :boolean, default: true
  end
end
