class AddUnservableToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :unservable, :boolean
  end
end
