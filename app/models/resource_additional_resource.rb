class ResourceAdditionalResource < ActiveRecord::Base
  belongs_to :resource
  belongs_to :additional_resource, class_name: 'Resource', foreign_key: 'additional_resource_id'
end
