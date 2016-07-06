class ContentGuidePdfUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "content_guides/#{model.id}"
  end
end
