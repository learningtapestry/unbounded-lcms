module Content
  class LobjectDescription < ActiveRecord::Base
    belongs_to :lobject
    belongs_to :document
  end
end
