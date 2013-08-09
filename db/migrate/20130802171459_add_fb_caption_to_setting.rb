class AddFbCaptionToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :fb_caption, :string
  end
end
