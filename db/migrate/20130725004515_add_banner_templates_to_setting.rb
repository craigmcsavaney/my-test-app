class AddBannerTemplatesToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :banner_template_1, :string
    add_column :settings, :banner_template_2, :string
    add_column :settings, :banner_template_3, :string
    add_column :settings, :banner_template_4, :string
    add_column :settings, :banner_template_5, :string
    add_column :settings, :banner_template_6, :string
    add_column :settings, :banner_template_7, :string
    add_column :settings, :banner_template_8, :string
  end
end
