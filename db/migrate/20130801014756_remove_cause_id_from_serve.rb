class RemoveCauseIdFromServe < ActiveRecord::Migration
  def up
    remove_column :serves, :cause_id
  end

  def down
    add_column :serves, :cause_id, :integer
  end
end
