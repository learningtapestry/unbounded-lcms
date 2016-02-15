class GoogleDocImage < ActiveRecord::Base
  mount_uploader :file, GoogleDocImageUploader
end
