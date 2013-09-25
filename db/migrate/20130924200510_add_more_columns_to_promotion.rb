class AddMoreColumnsToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :banner_template, :string, default: ""
  end
end
