class BackupUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "resource_backups/#{model.id}"
  end
end
