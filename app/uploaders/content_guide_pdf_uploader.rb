class ContentGuidePdfUploader < CarrierWave::Uploader::Base
  configure do |config|
    config.remove_previously_stored_files_after_update = false
  end

  def store_dir
    "content_guides/#{model.id}"
  end

  def fog_attributes
    { 'Content-Disposition' => 'attachment' }
  end
end
