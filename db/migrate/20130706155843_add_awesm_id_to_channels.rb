class AddAwesmIdToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :awesm, :string
  end
end
