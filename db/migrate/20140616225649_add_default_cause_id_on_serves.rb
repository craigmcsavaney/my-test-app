class AddDefaultCauseIdOnServes < ActiveRecord::Migration
  def up
  	add_column :serves, :default_cause_id, :integer
    Serve.all.each do |serve|
        serve.update_column(:default_cause_id, serve.promotion.cause_id)
    end
    change_column :serves, :default_cause_id, :integer, null: false 
  end
  def down
  	remove_column :serves, :default_cause_id
  end
end
