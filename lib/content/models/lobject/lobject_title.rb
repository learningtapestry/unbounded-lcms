module Content
  module Models
    class LobjectTitle < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :document

      # validates :title, presence: true
    end
  end
end
