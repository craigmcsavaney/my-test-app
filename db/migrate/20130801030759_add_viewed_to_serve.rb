class AddViewedToServe < ActiveRecord::Migration
  def change
    add_column :serves, :viewed, :boolean
  end
end
