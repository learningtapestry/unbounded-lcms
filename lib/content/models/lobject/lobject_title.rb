module Content
  module Models
    class LobjectTitle < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :document
    end
  end
end
