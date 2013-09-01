class AddUidToCause < ActiveRecord::Migration
  def change
    add_column :causes, :uid, :string
  end
end
