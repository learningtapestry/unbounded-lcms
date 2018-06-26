# frozen_string_literal: true

class AddMetadataToResources < ActiveRecord::Migration
  def change
    add_column :resources, :metadata, :jsonb, default: {}, null: false

    add_index :resources, :metadata, using: :gin
  end
end
