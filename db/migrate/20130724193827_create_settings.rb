class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
    	t.string :p_banner_1
    	t.string :facebook_default_msg
    	t.string :facebook_link_label
    	t.string :facebook_caption

      t.timestamps
    end
  end
end
