class ContentGuideImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/content_guide_images/#{model.id}"
  end
end
