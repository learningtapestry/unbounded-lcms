class AddDownloadCategoryToLobjectDownloads < ActiveRecord::Migration
  def change
    add_reference :lobject_downloads, :download_category, index: true, foreign_key: true
  end
end
