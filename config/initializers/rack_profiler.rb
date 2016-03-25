if Rails.env == 'development'
  require 'rack-mini-profiler'

  # Fix circular ref conflict with Oj.mimic_json
  module Rack
    class MiniProfiler
      module TimerStruct
        class Base
          def as_json
            @attributes
          end
        end
      end
    end
  end

  # initialization is skipped so trigger it
  Rack::MiniProfiler.config.position = 'right'
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
