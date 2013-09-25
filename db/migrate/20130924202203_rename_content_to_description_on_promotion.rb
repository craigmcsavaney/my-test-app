class RenameContentToDescriptionOnPromotion < ActiveRecord::Migration
  def change
    rename_column :promotions, :content, :description
  end
end
