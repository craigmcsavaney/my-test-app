class AddUidToEvents < ActiveRecord::Migration
  def change
    add_column :events, :uid, :string, null: false
  end
end
