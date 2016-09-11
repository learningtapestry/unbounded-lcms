class ContentGuidePdfUploader < CarrierWave::Uploader::Base
  def store_dir
    "content_guides/#{model.id}"
  end

  def fog_attributes
    { 'Content-Disposition' => 'attachment' }
  end
end
