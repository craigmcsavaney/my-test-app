class AddFbLinkLabelToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :fb_link_label, :string
  end
end
