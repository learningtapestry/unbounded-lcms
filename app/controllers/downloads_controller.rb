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

    tracker = Staccato.tracker(ENV['GOOGLE_ANALYTICS_ID'])
    tracker.event(
      category: category,
      action: action,
      label: label
    )

    redirect_to @download.attachment_url
  end
end
