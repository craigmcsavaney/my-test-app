class AddColumnsToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :facebook_msg_template, :string, default: ""
    add_column :promotions, :twitter_msg_template, :string, default: ""
    add_column :promotions, :pinterest_msg_template, :string, default: ""
    add_column :promotions, :linkedin_msg_template, :string, default: ""
    add_column :promotions, :email_subject_template, :string, default: ""
    add_column :promotions, :email_body_template, :string, default: ""
    add_column :promotions, :email_subject, :string, default: ""
    add_column :promotions, :email_body, :string, default: ""
    add_column :promotions, :googleplus_msg_template, :string, default: ""
    add_column :promotions, :googleplus_msg, :string, default: ""
  end
end
