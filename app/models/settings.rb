class Settings < ActiveRecord::Base
  class << self
    def editing_enabled?
      settings.editing_enabled?
    end

    def settings
      last || Settings.create!
    end
  end
end
