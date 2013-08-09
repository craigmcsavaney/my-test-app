class AddFbMsgColumnsToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :fb_msg_1, :string
    add_column :settings, :fb_msg_2, :string
    add_column :settings, :fb_msg_3, :string
    add_column :settings, :fb_msg_4, :string
    add_column :settings, :fb_msg_5, :string
    add_column :settings, :fb_msg_6, :string
    add_column :settings, :fb_msg_7, :string
    add_column :settings, :fb_msg_8, :string
  end
end
