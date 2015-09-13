class AddTypeReferenceToLobjectCollections < ActiveRecord::Migration
  def change
    add_reference :lobject_collections, :lobject_collection_type, index: true, foreign_key: true
  end
end
