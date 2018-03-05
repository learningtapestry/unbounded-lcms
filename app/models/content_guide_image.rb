# frozen_string_literal: true

class ContentGuideImage < ActiveRecord::Base
  mount_uploader :file, ContentGuideImageUploader

  def self.find_or_create_by_original_url(value)
    create_with(remote_file_url: value).find_or_create_by!(original_url: value)
  rescue ActiveRecord::RecordInvalid
    Rails.logger.info("RecordInvalid on ContentGuideImage#find_or_create_by_original_url => #{value}")
    raise if Rails.env.test?
  end
end
