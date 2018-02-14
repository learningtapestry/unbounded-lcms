# frozen_string_literal: true

class ContentGuideImageUploader < CarrierWave::Uploader::Base
  def store_dir
    "content_guide_images/#{model.id}"
  end
end
