class AddDeletedToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :deleted, :boolean
  end
end
