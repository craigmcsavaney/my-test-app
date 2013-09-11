class AddCookieLifeToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :cookie_life, :integer
  end
end
