class RemoveFacebookLinkLabelFromSetting < ActiveRecord::Migration
  def up
    remove_column :settings, :facebook_link_label
  end

  def down
    add_column :settings, :facebook_link_label, :string
  end
end
