class AddColumnsToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :email_subject_template, :string
    add_column :settings, :email_body_template, :string
    add_column :settings, :googleplus_msg_template, :string
  end
end
