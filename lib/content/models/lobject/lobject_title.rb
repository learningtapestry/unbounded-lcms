module Content
  class LobjectTitle < ActiveRecord::Base
    belongs_to :lobject
    belongs_to :document
  end
end
