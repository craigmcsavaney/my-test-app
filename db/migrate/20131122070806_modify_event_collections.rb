class ModifyEventCollections < ActiveRecord::Migration
  def up
    add_column :event_collections, :group_id, :integer, null: false
    remove_column :event_collections, :uid
    rename_table :event_collections, :events
  end
end
