class AddEventIdToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :event_id, :integer
  end
end
