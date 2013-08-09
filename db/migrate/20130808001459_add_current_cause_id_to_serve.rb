class AddCurrentCauseIdToServe < ActiveRecord::Migration
  def change
    add_column :serves, :current_cause_id, :integer
  end
end
