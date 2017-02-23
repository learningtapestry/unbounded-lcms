class AddThumbnailsLastUpdateToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :thumbnails_last_update, :datetime
  end
end
