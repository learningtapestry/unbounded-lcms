class DownloadsController < ApplicationController
  def show
    @download = Download.find(params[:id])

    tracker = Staccato.tracker(ENV['GOOGLE_ANALYTICS_ID'])
    tracker.event(
      category: 'download',
      action: @download.attachment_content_type,
      label: @download.attachment_url
    )

    redirect_to @download.attachment_url
  end
end
