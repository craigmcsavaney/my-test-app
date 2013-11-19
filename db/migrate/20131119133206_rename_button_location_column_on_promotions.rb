class RenameButtonLocationColumnOnPromotions < ActiveRecord::Migration
  def up
    rename_column :promotions, :button_location_id, :widget_location_id
  end
end
