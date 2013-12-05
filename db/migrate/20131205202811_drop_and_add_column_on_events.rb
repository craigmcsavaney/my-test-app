class DropAndAddColumnOnEvents < ActiveRecord::Migration
  def up
	remove_column :events, :end_date
	add_column :events, :end_date, :date
  end
end
