class StaffImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/staff_images/#{model.id}"
  end
end
