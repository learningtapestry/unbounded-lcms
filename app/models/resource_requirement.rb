class ResourceRequirement < ActiveRecord::Base
  belongs_to :resource
  belongs_to :requirement, class_name: 'Resource', foreign_key: 'requirement_id'
end
