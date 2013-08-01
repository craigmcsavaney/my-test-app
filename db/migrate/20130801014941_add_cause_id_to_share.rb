class AddCauseIdToShare < ActiveRecord::Migration
  def change
    add_column :shares, :cause_id, :integer
  end
end
