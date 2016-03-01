module DownloadHelper
  def attachment_content_type(download)
    case download.content_type
    when 'application/zip' then 'zip'
    when 'application/pdf' then 'pdf'
    when 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' then 'excel'
    when 'application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.presentation' then 'powerpoint'
    when 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' then 'doc'
    else download.content_type
    end
  end

  def attachment_url(download)
    if download.url.present?
      download.url.sub('public://', 'http://k12-content.s3-website-us-east-1.amazonaws.com/')
    else
      download.file.url
    end
  end

  def file_icon(type)
    %w(excel doc pdf powerpoint zip).include?(type) ? type : 'unknown'
  end
end
