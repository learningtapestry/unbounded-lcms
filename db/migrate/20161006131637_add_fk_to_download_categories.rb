class AddFkToDownloadCategories < ActiveRecord::Migration

  def up
    remove_foreign_key :resource_downloads, :download_categories
    add_foreign_key :resource_downloads, :download_categories, on_delete: :nullify
  end

  def down
    remove_foreign_key :resource_downloads, :download_categories
  end

end
