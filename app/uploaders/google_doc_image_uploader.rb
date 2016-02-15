class GoogleDocImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/google_doc_images/#{model.id}"
  end
end
