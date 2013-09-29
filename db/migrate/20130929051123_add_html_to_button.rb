class AddHtmlToButton < ActiveRecord::Migration
  def change
    add_column :buttons, :html, :string, default: ""
  end
end
