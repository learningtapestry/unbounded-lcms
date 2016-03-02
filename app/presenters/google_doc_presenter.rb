class GoogleDocPresenter < SimpleDelegator
  include Rails.application.routes.url_helpers

  CUSTOM_TAG_ELEMENT = 'h4'
  TASK_CLASS = 'googleDoc__task'

  DanglingLink = Struct.new(:text, :url)
  Heading = Struct.new(:id, :level, :text)

  def initialize(google_doc, host)
    super(google_doc)
    default_url_options[:host] = host
  end

  def content
    @content ||= begin
      embed_audios
      embed_videos
      process_tasks
      replace_guide_links
      doc.to_s.html_safe
    end
  end

  def content_for_pdf
    @content_for_pdf ||= begin
      process_tasks(false)
      replace_guide_links
      replace_image_sources
      doc.to_s.html_safe
    end
  end

  def dangling_links
    @dangling_links ||= begin
      doc.css('a[href*="docs.google.com/document/d/"]').map do |a|
        file_id = GoogleDoc.file_id_from_url(a[:href])
        next unless file_id.present?

        DanglingLink.new(a.text, a[:href]) unless GoogleDoc.exists?(file_id: file_id)
      end.compact
    end
  end

  def headings
    headings =
      doc.css('h1, h2, h3').each_with_index.map do |h, i|
        id = "heading_#{i}"
        level = h.name[/\d/].to_i
        text = h.text.chomp.strip

        h[:id] = id
        
        Heading.new(id, level, text)
      end

    min_level = headings.map(&:level).minmax.first
    headings.each { |h| h.level -= min_level }
    headings
  end

  private

  def embed_audios
    doc.css('a[href*="soundcloud.com"]').each do |a|
      url = a[:href]
      src = URI('https://w.soundcloud.com/player')
      src.query = URI.encode_www_form(url: url)
      iframe = doc.document.create_element('iframe', frameborder: 'no', height: '166', scrolling: 'no', src: src, width: '100%')
      a.replace(iframe)
    end
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

  def process_tasks(process_images = true)
    doc.css(CUSTOM_TAG_ELEMENT).each do |tag|
      value = tag.text.chomp.strip
      next unless value =~ /<TASK(;\d+)?>/

      element = tag.next_sibling
      tag.remove
      next unless process_images

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
    end
  end

  def replace_guide_links
    doc.css('a[href*="docs.google.com/document/d/"]').each do |a|
      file_id = GoogleDoc.file_id_from_url(a[:href])
      if (google_doc = GoogleDoc.find_by_file_id(file_id))
        a.content = google_doc.name if a.text == a[:href]
        a[:href] = google_doc_url(google_doc)
      end
    end
  end

  def replace_image_sources
    path2public = Rails.root.join('public')
    doc.css('img[src^="/uploads"]').each do |img|
      img[:src] = "file://#{path2public}#{img[:src]}"
    end
  end
end
