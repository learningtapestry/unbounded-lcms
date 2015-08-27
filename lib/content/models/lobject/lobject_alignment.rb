module Content
  module Models
    class LobjectAlignment < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :document
      belongs_to :alignment
    end
  end
end