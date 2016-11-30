class DownloadsController < ApplicationController
  include AnalyticsTracking
  before_action :init_download
  before_action :ga_track, except: :pdf_proxy

  def show
    redirect_to @download.attachment_url
  end

  def preview
    RestClient.head(@download.attachment_url)
  rescue RestClient::ExceptionWithResponse => e
    render text: e.response, status: '404'
  end

  def pdf_proxy
    response = RestClient.get(@download.attachment_url)
    send_data response.body, type: response.headers[:content_type], disposition: 'inline'
  rescue RestClient::ExceptionWithResponse => e
    render text: e.response, status: '404'
  end

  private

  def init_download
    @download = Download.find(params[:id])
  end

  def ga_track
    action = show_with_slug_path(ResourceSlug.find(params[:slug_id]).value) if params[:slug_id]
    label = @download.attachment_url
    ga_track_download(action: action, label: label)
  end
end
