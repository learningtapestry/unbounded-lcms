require 'google/apis/drive_v3'

class GoogleDoc < ActiveRecord::Base
  CUSTOM_TAG_ELEMENT = 'h4'
  FOOTNOTES_CLASS = 'googleDoc__footnotes'
  TASK_CLASS = 'googleDoc__task'

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

  def embed_videos
    doc.css('a[href*="youtube.com/watch?"]').each do |a|
      url = URI(a[:href])
      params = Rack::Utils.parse_query(url.query)
      video_id = params['v']
      src = "https://www.youtube.com/embed/#{video_id}"
      iframe = doc.document.create_element('iframe', allowfullscreen: nil, frameborder: 0, height: 315, src: src, width: 560)
      a.replace(iframe)
    end
  end

  def mark_footnotes
    if (hr = doc.at_xpath('hr[following-sibling::div[.//a[starts-with(@id, "ftnt")]]]'))
      hr[:class] = FOOTNOTES_CLASS
    end
  end

  def process_content
    return unless original_content.present?

    self.content = Nokogiri::HTML(original_content).xpath('/html/body/*').to_s
    mark_footnotes
    process_external_links
    embed_videos
    process_tasks
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

  def process_tasks
    doc.css(CUSTOM_TAG_ELEMENT).each do |h3|
      value = h3.text.chomp.strip
      next unless value =~ /<TASK(;\d+)?>/

      element = h3.next_sibling

      loop do
        if (span = element.at_xpath('.//span[img]'))
          style = span[:style].gsub(/max-height:[^;]+;?/, '') rescue nil
          if (height = value[/\d+/])
            style = "max-height:#{height}px; #{style}"
          end
          span[:style] = style
          span[:class] = TASK_CLASS
          break
        end

        element = element.next_sibling
        break unless element
      end

      h3.remove
    end
  end

  def realign_tables
    doc.css('table').each do |table|
      style = table[:style].gsub(/margin-(left|right):[^;]+;?/, '') rescue nil
      table[:style] = "margin-left:auto;margin-right:auto;#{style}"
    end
  end
end
