class DownloadsController < ApplicationController
  include AnalyticsTracking

  def show
    @download = Download.find(params[:id])
    action = if params[:slug_id]
               show_with_slug_path(ResourceSlug.find(params[:slug_id]).value)
             else
               nil
             end
    label = @download.attachment_url
    ga_track_download(action: action, label: label)
    redirect_to @download.attachment_url
  end
end
