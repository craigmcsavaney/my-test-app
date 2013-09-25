class RenameColumnsOnSetting < ActiveRecord::Migration
  def change
    change_table :settings do |t|
      t.rename :tw_msg, :twitter_msg_template
      t.rename :pin_msg, :pinterest_msg_template
      t.rename :li_msg, :linkedin_msg_template
    end
  end
end
