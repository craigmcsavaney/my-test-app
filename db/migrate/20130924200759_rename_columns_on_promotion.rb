class RenameColumnsOnPromotion < ActiveRecord::Migration
  def change
    change_table :promotions do |t|
      t.rename :fb_msg, :facebook_msg
      t.rename :tw_msg, :twitter_msg
      t.rename :pin_msg, :pinterest_msg
      t.rename :li_msg, :linkedin_msg
    end
  end
end
