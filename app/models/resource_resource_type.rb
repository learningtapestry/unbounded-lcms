class ResourceResourceType < ActiveRecord::Base
  belongs_to :resource
  belongs_to :resource_type
end
