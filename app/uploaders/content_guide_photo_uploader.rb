class ContentGuidePhotoUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/content_guides/#{model.id}"
  end
end
