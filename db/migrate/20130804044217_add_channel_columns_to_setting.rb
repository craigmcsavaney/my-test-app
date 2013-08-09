class AddChannelColumnsToSetting < ActiveRecord::Migration
  def change
      add_column :settings, :tw_msg, :string
      add_column :settings, :pin_msg, :string
      add_column :settings, :pin_image_url, :string
      add_column :settings, :pin_def_board, :string
      add_column :settings, :pin_thumb_url, :string
      add_column :settings, :li_msg, :string
  end
end
