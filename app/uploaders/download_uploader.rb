class DownloadUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "attachments/#{model.id}"
  end

  def fog_attributes
    { 'Content-Disposition' => 'attachment' }
  end
end
