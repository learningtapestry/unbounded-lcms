module Content
  class LobjectDocument < ActiveRecord::Base
    belongs_to :lobject
    belongs_to :document
  end
end
