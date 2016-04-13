require 'google/apis/drive_v3'

class ContentGuide < ActiveRecord::Base
  validates :date, :description, :grade, :subject, :teaser, :title, presence: true, if: :validate_metadata?

  before_create :process_content

  mount_uploader :big_photo, ContentGuidePhotoUploader
  mount_uploader :small_photo, ContentGuidePhotoUploader

  class << self
    def file_id_from_url(url)
      url.scan(/\/d\/([^\/]+)\//).first.first rescue nil
    end

    def import(file_id, credentials)
      service = Google::Apis::DriveV3::DriveService.new
      service.authorization = credentials

      file = service.get_file(file_id, fields: 'lastModifyingUser,modifiedTime,name,version')
      content = service.export_file(file_id, 'text/html').encode('ASCII-8BIT').force_encoding('UTF-8')

      cg = find_or_initialize_by(file_id: file_id)
      cg.update!(name: file.name,
                  last_modified_at: file.modified_time,
                  last_modifying_user_email: file.last_modifying_user.email_address,
                  last_modifying_user_name: file.last_modifying_user.display_name,
                  original_content: content,
                  version: file.version)
      cg
    end
  end

  def modified_by
    "#{last_modifying_user_name} <#{last_modifying_user_email}>" if last_modifying_user_name.present?
  end

  def original_url
    "https://docs.google.com/document/d/#{file_id}/edit"
  end

  def validate_metadata
    @validate_metadata = true
    valid?
  end

  private

  def download_images(doc)
    doc.css('img').each do |img|
      url = img[:src]
      if (image = (ContentGuideImage.create_with(remote_file_url: url).find_or_create_by!(original_url: url)))
        img[:src] = image.file.url
      end
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
    body = process_metadata(body)
    self.content = body.to_s
  end

  def process_metadata(doc)
    table = doc.at_css('table')
    return doc unless table

    table.css('tr').each do |tr|
      key, value = tr.css('td').map(&:content).map(&:strip)
      case key
      when 'ccss' then
      when 'related_instruction_tags' then
      when 'big_photo', 'small_photo' then send("remote_#{key}_url=", value)
      else send("#{key}=", value)
      end
    end

    table.remove
    doc
  end

  def validate_metadata?
    !!@validate_metadata
  end
end
