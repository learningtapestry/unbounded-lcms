module Content
  module Models
    class LobjectTitle < ActiveRecord::Base
      belongs_to :lobject, touch: true
      belongs_to :document
    end
  end
end
