class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
  		t.references :share,    null: false
  		t.integer :amount_cents, null: false, default: 0
  		t.string :transaction_id
        t.boolean :deleted

        t.timestamps
    end
  end
end
