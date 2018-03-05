# frozen_string_literal: true

class AddUnitBundlesToDownloadCategories < ActiveRecord::Migration
  def change
    add_column :download_categories, :bundle, :boolean, null: false, default: false
  end
end
