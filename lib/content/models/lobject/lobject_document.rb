module Content
  module Models
    class LobjectDocument < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :document
    end
  end
end
