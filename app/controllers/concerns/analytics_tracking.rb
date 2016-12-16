require 'staccato/adapter/logger'

module AnalyticsTracking
  extend ActiveSupport::Concern

  included do
    attr_writer :ga_client_id
    attr_writer :ga_id

    GA_DEBUG_MODE = false

    def ga_client_id
      # Last two char sequences, separated by a dot char ".":
      @ga_client_id ||= if cookies['_ga'].present?
                          cookies['_ga'].split('.').last(2).join('.')
                        end
    end

    def ga_id
      @ga_id ||= ENV['GOOGLE_ANALYTICS_ID']
    end

    def ga_track_download(action:, label:, category:)
      return if ga_client_id.blank?
      return if is_googlebot?(ua: request.user_agent)

      category ||= 'download'
      ga_tracker.event(category: category, action: action, label: label)
    end

    def is_googlebot?(ua:)
      ua.to_s.downcase.include?('googlebot')
    end

    private

    def ga_tracker(options: {})
      # @see options in Staccato::Hit::GLOBAL_OPTIONS
      Staccato.tracker(ga_id, ga_client_id, options) do |c|
        if GA_DEBUG_MODE
          c.adapter = Staccato::Adapter::Logger.new(
            Staccato.ga_collection_uri,
            Logger.new(STDOUT),
            lambda {|params| JSON.dump(params)}
          )
        end
      end
    end

  end # ... included

end
