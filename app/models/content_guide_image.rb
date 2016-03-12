class ContentGuideImage < ActiveRecord::Base
  mount_uploader :file, ContentGuideImageUploader
end
