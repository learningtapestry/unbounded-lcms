class BackupUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/resource_backups/#{model.id}"
  end
end
