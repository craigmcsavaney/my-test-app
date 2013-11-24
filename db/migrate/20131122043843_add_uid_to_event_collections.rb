class AddUidToEventCollections < ActiveRecord::Migration
  def change
    add_column :event_collections, :uid, :string, null: false

    add_index :event_collections, :uid, unique: true
  end
end
