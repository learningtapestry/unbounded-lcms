class ResourceSlug < ActiveRecord::Base
  belongs_to :resource
  belongs_to :curriculum
end
