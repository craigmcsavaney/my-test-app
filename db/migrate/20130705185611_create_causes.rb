class CreateCauses < ActiveRecord::Migration
  def change
    create_table :causes do |t|
      t.string :name

      t.timestamps
    end
  	add_index :causes, :name, unique: true
  end
end
