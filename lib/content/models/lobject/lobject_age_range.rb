module Content
  class LobjectAgeRange < ActiveRecord::Base
    belongs_to :lobject
    belongs_to :document

    def full
      str = "#{min_age}"
      str += "-#{max_age}" if max_age
      str += "+" if extended_age
      str
    end
  end
end
