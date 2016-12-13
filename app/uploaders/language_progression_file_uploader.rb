class LanguageProgressionFileUploader < CarrierWave::Uploader::Base
  def store_dir
    "language_progressions/#{model.id}"
  end
end
