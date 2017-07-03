class DownloadsController < ApplicationController
  include ActionController::Live
  include AnalyticsTracking

  before_action :ga_track, except: %i(pdf_proxy preview)

  def show
    redirect_to attachment_url
  end

  def preview
    ga_track('preview')
    @resource = resource_download.resource
    RestClient.head(attachment_url)
  rescue RestClient::ExceptionWithResponse => e
    render text: e.response, status: '404'
  end

  def pdf_proxy
    uri = URI(attachment_url)
    response.headers['Content-Disposition'] = 'inline'
    response.headers['Content-Type'] = 'application/pdf'
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      s3_request = Net::HTTP::Get.new(uri)
      http.request(s3_request) do |s3_response|
        s3_response.read_body { |chunk| response.stream.write(chunk) }
      end
    end
  ensure
    response.stream.close
  end

  private

  def attachment_url
    if params[:type] == 'standard'
      Standard.find(params[:id]).attachment_url
    else
      download.attachment_url
    end
  end

  def resource_download
    @resource_download ||= ResourceDownload.find(params[:id])
  end

  def download
    @download ||= resource_download.download
  end

  def ga_track(category = nil)
    action = show_with_slug_path(params[:slug]) if params[:slug].present?
    ga_track_download(action: action, label: attachment_url, category: category)
  end
end
