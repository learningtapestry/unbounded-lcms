class LanguageProgressionFileUploader < CarrierWave::Uploader::Base
  def store_dir
    "language_progressions/#{mounted_as}/#{model.id}"
  end
end
