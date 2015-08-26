module Content
  class LobjectResourceType < ActiveRecord::Base
    belongs_to :lobject
    belongs_to :document
    belongs_to :resource_type
  end
end
