class RemoveParentFromDocumentPart < ActiveRecord::Migration
  def change
    remove_reference :document_parts, :parent, index: true
  end
end
