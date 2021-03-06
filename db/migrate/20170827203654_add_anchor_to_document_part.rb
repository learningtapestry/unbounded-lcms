# frozen_string_literal: true

class AddAnchorToDocumentPart < ActiveRecord::Migration
  def change
    add_column :document_parts, :anchor, :string
    add_index :document_parts, :anchor
  end
end
