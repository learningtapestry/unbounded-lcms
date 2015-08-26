module Content
  class LobjectLanguage < ActiveRecord::Base
    belongs_to :lobject
    belongs_to :document
    belongs_to :language
  end
end
