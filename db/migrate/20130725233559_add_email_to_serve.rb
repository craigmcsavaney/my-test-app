class AddEmailToServe < ActiveRecord::Migration
  def change
    add_column :serves, :email, :string
  end
end
