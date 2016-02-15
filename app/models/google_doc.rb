require 'google/apis/drive_v3'

class GoogleDoc < ActiveRecord::Base
  before_save :process_content
  after_save :download_images

  def self.import(file_id, credentials)
    service = Google::Apis::DriveV3::DriveService.new
    service.authorization = credentials

    file = service.get_file(file_id)
    content = service.export_file(file_id, 'text/html').encode('ASCII-8BIT').force_encoding('UTF-8')

    doc = find_or_initialize_by(file_id: file_id)
    doc.update!(name: file.name, original_content: content)
    doc
  end

  def doc
    @doc ||= Nokogiri::HTML.fragment(content)
  end

  private

  def download_images
    doc.css('img').each do |img|
      url = img[:src]
      image = GoogleDocImage.create_with(remote_file_url: url).find_or_create_by!(original_url: url)
      img[:src] = image.file.url
    end
    update_column(:content, doc.to_s)
  end

  def process_content
    return unless original_content.present?

    doc = Nokogiri::HTML(original_content).xpath('/html/body/*')
    doc = realign_tables(doc)
    self.content = doc.to_s
  end

  def realign_tables(doc)
    left_margin_regex = /margin-left:\s*(auto|-?\d+)/
    doc.css('table').each do |table|
      table[:style] = table[:style].gsub(left_margin_regex, 'margin-left:0') rescue nil
    end
    doc
  end
end
