class AddParentPathToServe < ActiveRecord::Migration
  def change
    add_column :serves, :parent_path, :string
  end
end
