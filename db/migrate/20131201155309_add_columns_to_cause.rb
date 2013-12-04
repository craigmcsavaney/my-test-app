class AddColumnsToCause < ActiveRecord::Migration
  def change
    add_column :causes, :fg_uuid, :string, default: ""
    add_column :causes, :fg_type_id, :integer
    add_column :causes, :alias, :string, default: ""
    add_column :causes, :abstract, :string, default: ""
    add_column :causes, :ein, :integer
    add_column :causes, :fg_parent_uuid, :string, default: ""
    add_column :causes, :address_line_1, :string, default: ""
    add_column :causes, :address_line_2, :string, default: ""
    add_column :causes, :address_line_3, :string, default: ""
    add_column :causes, :address_line_full, :string, default: ""
    add_column :causes, :city, :string, default: ""
    add_column :causes, :region, :string, default: ""
    add_column :causes, :postal_code, :string, default: ""
    add_column :causes, :county, :string, default: ""
    add_column :causes, :country, :string, default: ""
    add_column :causes, :address_full, :string, default: ""
    add_column :causes, :phone_number, :string, default: ""
    add_column :causes, :area_code, :string, default: ""
    add_column :causes, :url, :string, default: ""
    add_column :causes, :fg_category_code, :string, default: ""
    add_column :causes, :fg_category_title, :string, default: ""
    add_column :causes, :fg_category_description, :string, default: ""
    add_column :causes, :latitude, :string, default: ""
    add_column :causes, :longitude, :string, default: ""
    add_column :causes, :fg_revoked, :string, default: ""
    add_column :causes, :fg_locale_db_id, :string, default: ""
  end
end
