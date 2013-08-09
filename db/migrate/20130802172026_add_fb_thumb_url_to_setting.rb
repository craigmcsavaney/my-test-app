class AddFbThumbUrlToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :fb_thumb_url, :string
  end
end
