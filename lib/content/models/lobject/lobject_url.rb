module Content
  module Models
    class LobjectUrl < ActiveRecord::Base
      belongs_to :lobject
      belongs_to :url
    end
  end
end
