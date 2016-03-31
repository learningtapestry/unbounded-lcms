require 'google/apis/drive_v3'

class ContentGuide < ActiveRecord::Base
  before_save :process_content

  class << self
    def file_id_from_url(url)
      url.scan(/\/d\/([^\/]+)\//).first.first rescue nil
    end

    def import(file_id, credentials)
      service = Google::Apis::DriveV3::DriveService.new
      service.authorization = credentials

      file = service.get_file(file_id, fields: 'lastModifyingUser,modifiedTime,name,version')
      content = service.export_file(file_id, 'text/html').encode('ASCII-8BIT').force_encoding('UTF-8')

      doc = find_or_initialize_by(file_id: file_id)
      doc.update!(name: file.name,
                  last_modified_at: file.modified_time,
                  last_modifying_user_email: file.last_modifying_user.email_address,
                  last_modifying_user_name: file.last_modifying_user.display_name,
                  original_content: content,
                  version: file.version)
      doc
    end
  end

  def modified_by
    "#{last_modifying_user_name} <#{last_modifying_user_email}>"
  end

  def original_url
    "https://docs.google.com/document/d/#{file_id}/edit"
  end

  private

  def download_images(doc)
    doc.css('img').each do |img|
      url = img[:src]
      image = ContentGuideImage.create_with(remote_file_url: url).find_or_create_by!(original_url: url)
      img[:src] = image.file.url
    end
    doc
  end

  def extract_links(doc)
    doc.css('a[href^="https://www.google.com/url"]').each do |a|
      url = URI(a[:href])
      params = Rack::Utils.parse_query(url.query)
      a[:href] = params['q']
      a[:target] = '_blank'
    end
    doc
  end

  def process_content
    doc = Nokogiri::HTML(original_content)
    body_str = doc.xpath('/html/body/*').to_s
    body = Nokogiri::HTML.fragment(body_str)
    body = download_images(body)
    body = extract_links(body)
    self.content = body.to_s
  end
end
