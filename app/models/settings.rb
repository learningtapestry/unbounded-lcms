class Settings < ActiveRecord::Base
  class << self
    def editing_enabled?
      settings.editing_enabled?
    end

    def thumbnails_last_update
      settings.thumbnails_last_update
    end

    def settings
      last || Settings.create!
    end
  end
end
