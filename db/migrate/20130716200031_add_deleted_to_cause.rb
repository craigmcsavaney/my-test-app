class AddDeletedToCause < ActiveRecord::Migration
  def change
    add_column :causes, :deleted, :boolean
  end
end
