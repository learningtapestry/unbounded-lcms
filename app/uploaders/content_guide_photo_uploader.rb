class ContentGuidePhotoUploader < CarrierWave::Uploader::Base
  def store_dir
    "content_guides/#{model.id}"
  end
end
