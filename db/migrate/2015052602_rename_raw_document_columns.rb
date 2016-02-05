class RenameRawDocumentColumns < ActiveRecord::Migration
  def change
    rename_column :conformed_documents, :raw_document_id, :lr_document_id
  end
end
