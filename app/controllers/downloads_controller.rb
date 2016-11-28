class DownloadsController < ApplicationController
  include AnalyticsTracking
  before_action :init_download

  def show
    redirect_to @download.attachment_url
  end

  def preview
    RestClient.head(@download.attachment_url)
    s3_path = URI.parse(@download.attachment_url).path
    @pdf_url = "#{request.base_url}/pdf_proxy#{s3_path}"
    @pdf_filename = File.basename(s3_path)
  rescue RestClient::ExceptionWithResponse => e
    render text: e.response, status: '404'
  end

  private

  def init_download
    @download = Download.find(params[:id])
    action = show_with_slug_path(ResourceSlug.find(params[:slug_id]).value) if params[:slug_id]
    label = @download.attachment_url
    ga_track_download(action: action, label: label)
  end
end
