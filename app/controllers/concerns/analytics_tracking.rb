require 'staccato/adapter/logger'

module AnalyticsTracking
  extend ActiveSupport::Concern

  included do
    attr_writer :ga_client_id
    attr_writer :ga_id

    GA_DEBUG_MODE = false

    def ga_client_id
      @ga_client_id ||= /[^\.]+\.[^\.]+$/.match(cookies["_ga"]).to_s.presence
    end

    def ga_id
      @ga_id ||= ENV['GOOGLE_ANALYTICS_ID']
    end

    def ga_report_search(search_url:, referrer:)
      return if ga_client_id.blank?
      return if is_googlebot?(ua: request.user_agent)

      ga_tracker(options: {document_location: search_url})
        .pageview(referrer: referrer)
    end

    def ga_track_download(action:, label:)
      return if ga_client_id.blank?
      return if is_googlebot?(ua: request.user_agent)

      ga_tracker.event(
        category: 'download',
        action: action,
        label: label
      )
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
