class ResourceImageUploader < CarrierWave::Uploader::Base
  def store_dir
    "resource_images/#{model.id}"
  end
end
