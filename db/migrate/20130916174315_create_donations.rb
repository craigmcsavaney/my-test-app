class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
  		t.references :sale,    null: false
  		t.references :merchant,    null: false
  		t.references :cause,    null: false
  		t.string :chosen_by, null: false
  		t.integer :amount_cents, null: false, default: 0
  		t.string :choosers_email, default: ""
        t.boolean :deleted

      t.timestamps
    end
  end
end
