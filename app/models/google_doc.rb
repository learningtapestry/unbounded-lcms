require 'google/apis/drive_v3'

class GoogleDoc < ActiveRecord::Base
  FOOTNOTES_CLASS = 'googleDoc__footnotes'
  KEYWORD_CLASS = 'googleDoc__keyword'

  before_save :process_content
  after_save :download_images

  class << self
    def file_id_from_url(url)
      url.scan(/\/d\/([^\/]+)\//).first.first rescue nil
    end

    def import(file_id, credentials)
      service = Google::Apis::DriveV3::DriveService.new
      service.authorization = credentials

      file = service.get_file(file_id)
      content = service.export_file(file_id, 'text/html').encode('ASCII-8BIT').force_encoding('UTF-8')

      doc = find_or_initialize_by(file_id: file_id)
      doc.update!(name: file.name, original_content: content)
      doc
    end
  end

  def doc
    @doc ||= Nokogiri::HTML.fragment(content)
  end

  def original_url
    "https://docs.google.com/document/d/#{file_id}/edit"
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

  def mark_footnotes
    if (hr = doc.at_xpath('hr[following-sibling::div[.//a[starts-with(@id, "ftnt")]]]'))
      hr[:class] = FOOTNOTES_CLASS
    end
  end

  def process_content
    return unless original_content.present?

    content = wrap_keywords(original_content)
    self.content = Nokogiri::HTML(content).xpath('/html/body/*').to_s
    mark_footnotes
    process_external_links
    realign_tables

    self.content = doc.to_s
  end

  def process_external_links
    doc.css('a[href^="https://www.google.com/url"]').each do |a|
      url = URI(a[:href])
      params = Rack::Utils.parse_query(url.query)
      a[:href] = params['q']
    end
  end

  def realign_tables
    doc.css('table').each do |table|
      style = table[:style].gsub(/margin-(left|right):[^;]+;?/, '') rescue nil
      table[:style] = "margin-left:auto;margin-right:auto;#{style}"
    end
  end

  def wrap_keywords(content)
    result = content.dup

    keywords = GoogleDocDefinition.all.map { |d| [d.keyword, d.description] }

    GoogleDocStandard.all.each do |standard|
      keywords << [standard.name, standard.description]
    end
    
    keywords.each do |keyword, value|
      value.gsub!('"', '&quot;')
      node = %Q(<span class=#{KEYWORD_CLASS} data-description="#{value}">#{keyword}</span>)
      result.gsub!(/(>|\s)#{keyword}(\.\W|[^.\w])/i) { |m| m.gsub!(keyword, node) }
    end

    result
  end
end
