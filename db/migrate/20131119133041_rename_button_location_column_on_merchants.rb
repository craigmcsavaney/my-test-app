class RenameButtonLocationColumnOnMerchants < ActiveRecord::Migration
  def up
    rename_column :merchants, :button_location_id, :widget_location_id
  end
end
