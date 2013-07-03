class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :content
      t.date :start_date
      t.date :end_date
      t.integer :merchant_id

      t.timestamps
    end
    add_index :promotions, [:merchant_id]
  end
end
