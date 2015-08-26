module Content
  class LobjectSubject < ActiveRecord::Base
    belongs_to :lobject
    belongs_to :document
    belongs_to :subject
  end
end
