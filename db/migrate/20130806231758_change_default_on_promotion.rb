class ChangeDefaultOnPromotion < ActiveRecord::Migration
  def up
  	change_column :promotions, :content, :string, :default => ""
  	change_column :promotions, :name, :string, :default => ""
  	change_column :promotions, :landing_page, :string, :default => ""
  	change_column :promotions, :banner, :string, :default => ""
  	change_column :promotions, :fb_msg, :string, :default => ""
  	change_column :promotions, :fb_link_label, :string, :default => ""
  	change_column :promotions, :fb_caption, :string, :default => ""
  	change_column :promotions, :fb_redirect_url, :string, :default => ""
  	change_column :promotions, :fb_thumb_url, :string, :default => ""
  	change_column :promotions, :tw_msg, :string, :default => ""
  	change_column :promotions, :pin_msg, :string, :default => ""
  	change_column :promotions, :pin_image_url, :string, :default => ""
  	change_column :promotions, :pin_def_board, :string, :default => ""
  	change_column :promotions, :pin_thumb_url, :string, :default => ""
  	change_column :promotions, :li_msg, :string, :default => ""
  end
end
