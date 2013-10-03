class AddUrlPrefixToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :url_prefix, :string, default: ""
  end
end
