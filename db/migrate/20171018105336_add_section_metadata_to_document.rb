# frozen_string_literal: true

class AddSectionMetadataToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :sections_metadata, :jsonb
  end
end
