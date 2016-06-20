class ResourceImageUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "resource_images/#{model.id}"
  end
end
