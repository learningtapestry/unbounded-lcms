class ContentGuideImageUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "content_guide_images/#{model.id}"
  end
end
