class StaffImageUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "staff_images/#{model.id}"
  end
end
