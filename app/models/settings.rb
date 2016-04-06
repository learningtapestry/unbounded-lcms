class Settings < ActiveRecord::Base
  class << self
    def editing_enabled?
      !!settings.try(:editing_enabled?)
    end

    def settings
      @settings ||= (last || Settings.create!)
    end
  end
end
