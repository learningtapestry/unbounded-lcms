class ChangeConformedDocumentsAddRawDocument < ActiveRecord::Migration
  def change
    change_table :conformed_documents do |t|
      t.references :raw_document, references: :raw_documents
    end
  end
end
