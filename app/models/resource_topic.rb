class ResourceTopic < ActiveRecord::Base
  belongs_to :resource
  belongs_to :topic
end
