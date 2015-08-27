module Content
  module Models
    class LobjectGrade < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :document
      belongs_to :grade
    end
  end
end
