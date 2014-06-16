class AddDisplayOrderToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :display_order, :integer
  end
end
