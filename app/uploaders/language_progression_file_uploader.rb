class LanguageProgressionFileUploader < CarrierWave::Uploader::Base
  def store_dir
    "language_progressions/#{mounted_as}/#{model.id}"
  end

  def fog_attributes
    { 'Content-Disposition' => 'attachment' }
  end
end
