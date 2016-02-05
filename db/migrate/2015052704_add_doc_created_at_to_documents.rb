class AddDocCreatedAtToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :doc_created_at, :timestamp
  end
end
