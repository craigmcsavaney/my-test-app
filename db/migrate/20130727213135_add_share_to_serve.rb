class AddShareToServe < ActiveRecord::Migration
  def change
    add_column :serves, :share_id, :integer
  end
end
