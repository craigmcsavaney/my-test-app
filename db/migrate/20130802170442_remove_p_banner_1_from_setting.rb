class RemovePBanner1FromSetting < ActiveRecord::Migration
  def up
    remove_column :settings, :p_banner_1
  end

  def down
    add_column :settings, :p_banner_1, :string
  end
end
