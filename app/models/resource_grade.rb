class ResourceGrade < ActiveRecord::Base
  belongs_to :resource
  belongs_to :grade
end
