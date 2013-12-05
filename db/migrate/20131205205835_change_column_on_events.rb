class ChangeColumnOnEvents < ActiveRecord::Migration
  def up
  	change_column :events, :end_date, :date, null: true
  end
end
