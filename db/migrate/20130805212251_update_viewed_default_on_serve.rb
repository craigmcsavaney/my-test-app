class UpdateViewedDefaultOnServe < ActiveRecord::Migration
  def up
  	change_column :serves, :viewed, :boolean, :default => false
  end
end
