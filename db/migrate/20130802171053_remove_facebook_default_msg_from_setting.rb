class RemoveFacebookDefaultMsgFromSetting < ActiveRecord::Migration
  def up
    remove_column :settings, :facebook_default_msg
  end

  def down
    add_column :settings, :facebook_default_msg, :string
  end
end
