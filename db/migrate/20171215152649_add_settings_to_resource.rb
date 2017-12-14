# frozen_string_literal: true

class AddSettingsToResource < ActiveRecord::Migration
  def change
    add_column :resources, :download_categories_settings, :jsonb, default: {}, null: false
  end
end
