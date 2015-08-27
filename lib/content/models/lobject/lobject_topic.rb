module Content
  module Models
    class LobjectTopic < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :document
      belongs_to :topic
    end
  end
end
