class AddTypeToCauses < ActiveRecord::Migration
  def change
    add_column :causes, :type, :string
    add_index :causes, :type

  end
end
