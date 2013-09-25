class RenameFbMsgColumnsOnSetting < ActiveRecord::Migration
  def change
    change_table :settings do |t|
      t.rename :fb_msg_1, :fb_msg_template_1
      t.rename :fb_msg_2, :fb_msg_template_2
      t.rename :fb_msg_3, :fb_msg_template_3
      t.rename :fb_msg_4, :fb_msg_template_4
      t.rename :fb_msg_5, :fb_msg_template_5
      t.rename :fb_msg_6, :fb_msg_template_6
      t.rename :fb_msg_7, :fb_msg_template_7
      t.rename :fb_msg_8, :fb_msg_template_8
    end
  end
end
