# frozen_string_literal: true

class AddDataFieldToDocumentParts < ActiveRecord::Migration
  def change
    add_column :document_parts, :data, :jsonb, default: {}, null: false
  end
end
