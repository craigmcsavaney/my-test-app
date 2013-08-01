class AddCauseToServe < ActiveRecord::Migration
  def change
    add_column :serves, :cause_id, :integer
  end
end
