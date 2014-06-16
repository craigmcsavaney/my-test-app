class AddFontAwesomeIconNameToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :font_awesome_icon_name, :string, default: ""
  end
end
