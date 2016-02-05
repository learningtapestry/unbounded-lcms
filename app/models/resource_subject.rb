class ResourceSubject < ActiveRecord::Base
  belongs_to :resource
  belongs_to :subject
end
