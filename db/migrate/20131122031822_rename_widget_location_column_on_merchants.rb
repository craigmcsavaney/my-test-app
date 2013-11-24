class RenameWidgetLocationColumnOnMerchants < ActiveRecord::Migration
  def up
    rename_column :merchants, :widget_location_id, :widget_position_id
  end
end
