module ApplicationHelper
  def attachment_content_type(download)
    t("unbounded.content_type.#{download.content_type}") rescue download.content_type
  end

  def attachment_url(download)
    if download.url.present?
      download.url.sub('public://', 'http://k12-content.s3-website-us-east-1.amazonaws.com/')
    else
      download.file.url
    end
  end
end
