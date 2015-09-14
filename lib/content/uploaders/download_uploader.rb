module Content
  class DownloadUploader < CarrierWave::Uploader::Base
    storage :file

    def store_dir
      "uploads/attachments/#{model.id}"
    end
  end
end
