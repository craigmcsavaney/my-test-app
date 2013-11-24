class RenameWidgetLocationColumnOnPromotions < ActiveRecord::Migration
  def up
    rename_column :promotions, :widget_location_id, :widget_position_id
  end
end
