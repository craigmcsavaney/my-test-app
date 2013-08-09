class RenameColumnOnServe < ActiveRecord::Migration
  def up
    rename_column :serves, :share_id, :referring_share_id
  end
end
