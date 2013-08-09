class AddFacebookColumnsToPromotion < ActiveRecord::Migration
  def change
      add_column :promotions, :fb_msg, :string
      add_column :promotions, :fb_link_label, :string
      add_column :promotions, :fb_caption, :string
      add_column :promotions, :fb_redirect_url, :string
      add_column :promotions, :fb_thumb_url, :string
  end
end
