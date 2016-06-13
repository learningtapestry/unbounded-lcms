class DownloadUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "attachments/#{model.id}"
  end
end
