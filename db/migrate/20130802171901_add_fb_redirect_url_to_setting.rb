class AddFbRedirectUrlToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :fb_redirect_url, :string
  end
end
