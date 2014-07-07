class AddPostIdOnShares < ActiveRecord::Migration
  def change
    add_column :shares, :post_id, :string
  end
end
