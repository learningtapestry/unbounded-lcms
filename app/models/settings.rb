# frozen_string_literal: true

class Settings < ActiveRecord::Base
  class << self
    def [](key)
      settings.data[key.to_s]
    end

    def []=(key, value)
      settings.update data: settings.data.merge(key.to_s => value)
    end

    private

    def settings
      last || create!(data: { editing_enabled: true })
    end
  end
end
