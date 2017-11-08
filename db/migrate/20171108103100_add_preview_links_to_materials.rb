# frozen_string_literal: true

class AddPreviewLinksToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :preview_links, :hstore, default: {}
  end
end
