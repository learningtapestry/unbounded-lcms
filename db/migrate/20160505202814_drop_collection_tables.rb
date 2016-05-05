class DropCollectionTables < ActiveRecord::Migration
  def change
    drop_table :resource_children
    drop_table :resource_collections
    drop_table :resource_collection_types
  end
end
