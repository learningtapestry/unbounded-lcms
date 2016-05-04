class ResourceImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/resource_images/#{model.id}"
  end
end
