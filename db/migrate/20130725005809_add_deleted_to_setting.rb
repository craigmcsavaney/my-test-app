class AddDeletedToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :deleted, :boolean
  end
end
