class AddChannelColumnsToPromotion < ActiveRecord::Migration
  def change
      add_column :promotions, :tw_msg, :string
      add_column :promotions, :pin_msg, :string
      add_column :promotions, :pin_image_url, :string
      add_column :promotions, :pin_def_board, :string
      add_column :promotions, :pin_thumb_url, :string
      add_column :promotions, :li_msg, :string
  end
end
