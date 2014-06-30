class AddServeCountToServes < ActiveRecord::Migration
  def change
    add_column :serves, :serve_count, :integer
    Serve.update_all(serve_count: 1);
    Serve.where(deleted: true).update_all(serve_count: 1);
    change_column :serves, :serve_count, :integer, null: false
  end
end
