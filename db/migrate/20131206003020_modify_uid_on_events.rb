class ModifyUidOnEvents < ActiveRecord::Migration
  def up
    change_column :events, :uid, :string, null: false
  end
end
