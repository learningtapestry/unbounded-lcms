class ChangeDocumentsSourceRef < ActiveRecord::Migration
  def up
    add_column :documents, :source_document_id, :integer, index: true
    add_foreign_key :documents, :source_documents

    Content::Document.order(id: :asc).find_each do |doc|
      if !doc.lr_document_id.nil?
        doc.source_document_id = Content::LrDocument.find(doc.lr_document_id).source_document.id
        doc.save
      end
    end

    remove_column :documents, :lr_document_id
  end

  def down
    add_column :documents, :lr_document_id, :integer, index: true
    add_foreign_key :documents, :lr_documents
    remove_column :documents, :source_document_id
  end
end
