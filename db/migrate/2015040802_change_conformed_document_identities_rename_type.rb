class ChangeConformedDocumentIdentitiesRenameType < ActiveRecord::Migration
  def change
    rename_column :conformed_document_identities, :type, :identity_type
  end
end
