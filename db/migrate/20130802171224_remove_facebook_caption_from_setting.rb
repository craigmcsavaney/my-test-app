class RemoveFacebookCaptionFromSetting < ActiveRecord::Migration
  def up
    remove_column :settings, :facebook_caption
  end

  def down
    add_column :settings, :facebook_caption, :string
  end
end
