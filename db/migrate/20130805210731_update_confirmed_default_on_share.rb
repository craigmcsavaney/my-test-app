class UpdateConfirmedDefaultOnShare < ActiveRecord::Migration
  def up
  	change_column :shares, :confirmed, :boolean, :default => false
  end
end
