class DownloadsController < ApplicationController
  def show
    @download = Download.find(params[:id])

    category = 'download'

    action = if params[:slug_id]
      show_with_slug_path(ResourceSlug.find(params[:slug_id]).value)
    else
      nil
    end

    label = @download.attachment_url

    ga_client_id = if cookies['_ga'].present?
      cookies['_ga'].split('.').last(2).join('.')
    else
      nil
    end

    tracker = Staccato.tracker(ENV['GOOGLE_ANALYTICS_ID'], ga_client_id)
    tracker.event(
      category: category,
      action: action,
      label: label
    )

    redirect_to @download.attachment_url
  end
end
