class DownloadsController < ApplicationController
  def show
    @download = Download.find(params[:id])
    track_download
    redirect_to @download.attachment_url
  end

  protected
    def track_download
      ga_client_id = if cookies['_ga'].present?
        cookies['_ga'].split('.').last(2).join('.')
      end

      return unless ga_client_id

      is_googlebot = request.user_agent.present? &&
        request.user_agent.downcase.include?('googlebot')

      return if is_googlebot

      action = if params[:slug_id]
        show_with_slug_path(ResourceSlug.find(params[:slug_id]).value)
      else
        nil
      end

      tracker = Staccato.tracker(ENV['GOOGLE_ANALYTICS_ID'], ga_client_id)
      tracker.event(
        category: 'download',
        action: action,
        label: @download.attachment_url
      )
    end
end
