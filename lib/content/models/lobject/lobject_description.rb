module Content
  module Models
    class LobjectDescription < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :document
    end
  end
end
