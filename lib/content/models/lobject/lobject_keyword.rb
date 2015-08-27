module Content
  module Models
    class LobjectKeyword < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :document
      belongs_to :keyword
    end
  end
end