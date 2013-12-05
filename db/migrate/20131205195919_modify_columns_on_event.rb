class ModifyColumnsOnEvent < ActiveRecord::Migration
  def up
  	change_column :events, :event_date, :date, null: false
  	change_column :events, :start_date, :date, null: false
  	change_column :events, :end_date, :date
  end
end
