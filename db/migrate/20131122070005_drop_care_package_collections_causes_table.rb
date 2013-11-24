class DropCarePackageCollectionsCausesTable < ActiveRecord::Migration
  def up
  		drop_table :care_package_collections_causes
  end
end
