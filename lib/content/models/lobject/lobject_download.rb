module Content
  module Models
    class LobjectDownload < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :document
      belongs_to :download
    end
  end
end
