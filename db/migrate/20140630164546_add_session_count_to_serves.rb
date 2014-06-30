class AddSessionCountToServes < ActiveRecord::Migration
  def change
    add_column :serves, :session_count, :integer
    Serve.update_all(session_count: 1);
    Serve.where(deleted: true).update_all(session_count: 1);
    change_column :serves, :session_count, :integer, null: false
  end
end
