class AddDisableMsgEditingToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :disable_msg_editing, :boolean
  end
end
