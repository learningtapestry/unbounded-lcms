module AnalyticsTracking
  extend ActiveSupport::Concern

  included do
    def track_download(action:, label:)
      ga_client_id = if cookies['_ga'].present?
                       cookies['_ga'].split('.').last(2).join('.')
                     end

      return unless ga_client_id

      is_googlebot = request.user_agent.present? &&
                     request.user_agent.downcase.include?('googlebot')

      return if is_googlebot

      tracker = Staccato.tracker(ENV['GOOGLE_ANALYTICS_ID'], ga_client_id)
      tracker.event(
        category: 'download',
        action: action,
        label: label
      )
    end
  end
end
