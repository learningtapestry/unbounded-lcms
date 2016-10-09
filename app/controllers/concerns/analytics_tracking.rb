require 'staccato/adapter/logger'

module AnalyticsTracking
  extend ActiveSupport::Concern

  included do
    attr_writer :ga_id
    attr_writer :ga_client_id

    def ga_id
      @ga_id ||= ENV['GOOGLE_ANALYTICS_ID']
    end

    def ga_client_id
      @ga_client_id ||= /[^\.]+\.[^\.]+$/.match(cookies["_ga"]).to_s.presence
    end

    def ga_tracker
      logger_adapter = Staccato::Adapter::Logger.new(
        Staccato.ga_collection_uri,
        Logger.new(STDOUT),
        lambda {|params| JSON.dump(params)}
      )
      Staccato.tracker(ga_id, ga_client_id) do |c|
        #c.adapter = logger_adapter # Uncomment to enable logging to console
      end
    end

    def ga_report_pageview(request:)
      return if ga_client_id.blank?
      options_hash = {
        hostname: request.host,
        path: request.fullpath,
        data_source: URI.parse(request.referrer).path,
        referrer: request.referrer,
      }
      hit = Staccato::Pageview.new(ga_tracker, options_hash)
      hit.track!
    end

    def ga_track_download(action:, label:)
      return if ga_client_id.blank?
      return if ua_is_googlebot?

      ga_tracker.event(
        category: 'download',
        action: action,
        label: label
      )
    end

    def ua_is_googlebot?
      request.user_agent.presence.to_s.downcase.include?('googlebot')
    end

  end
end
