class ContentGuidePresenter < SimpleDelegator
  include Rails.application.routes.url_helpers

  KEYWORD_CLASS = 'contengGuide__keyword'

  DanglingLink = Struct.new(:text, :url)
  Heading = Struct.new(:id, :level, :text)

  attr_reader :doc, :host, :view_context

  def initialize(content_guide, host, view_context, wrap_keywords: false)
    super(content_guide)

    default_url_options[:host] = host
    @host = host
    @view_context = view_context
    @wrap_keywords = wrap_keywords
    init_doc
  end

  def dangling_links
    @dangling_links ||= begin
      doc.css('a[href*="docs.google.com/document/d/"]').map do |a|
        file_id = ContentGuide.file_id_from_url(a[:href])
        next unless file_id.present?

        DanglingLink.new(a.text, a[:href]) unless ContentGuide.exists?(file_id: file_id)
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

  def html
    doc.to_s.html_safe
  end

  private

  def embed_audios
    urls_hash = {}

    doc.css('a[href*="soundcloud.com"]').each_with_index do |a, index|
      url = a[:href]
      id = "sc_container_#{index}"
      urls_hash[id] = url
      container = doc.document.create_element('div', id: id)
      a.replace(container)
    end

    return if urls_hash.empty?

    doc << doc.document.create_element('script', src: 'https://connect.soundcloud.com/sdk/sdk-3.0.0.js')

    script = doc.document.create_element('script')
    script.content = "SC.initialize({ client_id: '#{ENV['SOUNDCLOUD_CLIENT_ID']}' });\n"

    urls_hash.each do |id, url|
      script.content += "SC.oEmbed('#{url}', { element: document.getElementById('#{id}') });\n"
    end

    doc << script
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

  def find_custom_tags(tag_name, node = nil, &block)
    (node || doc).css('span').map do |span|
      if (span[:style] || '') =~ /font-weight:\s*bold/
        if span.content == "<#{tag_name}>"
          tag = span.parent
          yield tag if block
          tag
        end
      end
    end.compact
  end

  def next_element_with_name(tag, name)
    next_node = tag.next
    loop do
      return next_node if next_node.nil? || next_node.name == name
      next_node = next_node.next
    end
  end

  def process_blockquotes
    find_custom_tags('blockquotes') do |tag|
      table = next_element_with_name(tag, 'table')
      tag.remove
      return unless table
      return unless table.css('td').size == 1

      blockquote = doc.document.create_element('blockquote')
      blockquote.inner_html = table.at_css('td').inner_html
      table.replace(blockquote)
    end
  end

  def process_footnote_links
    doc.css('a[href^="#ftnt"]:not([href^="#ftnt_ref"])').each do |a|
      footnote = doc.at_css(a[:href]).ancestors('div').first.clone
      footnote.at_css(a[:href]).remove
      a['data-tooltip'] = true
      a[:title] = footnote.to_s
    end
  end

  def process_task_body(cell, with_break:)
    body = doc.document.create_element('div', class: 'c-cg-task__body')
    body.inner_html = cell.inner_html

    if (tag = find_custom_tags('task break', body).first)
      if with_break
        if (next_node = tag.next)
          hidden = doc.document.create_element('div', class: 'c-cg-task__hidden')
          loop do
            break unless next_node
            current_node = next_node
            next_node = current_node.next
            hidden << current_node.dup
            current_node.remove
          end

          toggler = doc.document.create_element('a', class: 'c-cg-task__toggler', href: '#')
          toggler.content = 'Show / Hide'

          wrap = doc.document.create_element('div')
          wrap << toggler
          wrap << hidden
          body << wrap
        end
      end

      tag.remove
    end
  
    body
  end

  def process_tasks(with_break: true)
    find_custom_tags('task') do |tag|
      table = next_element_with_name(tag, 'table')
      tag.remove
      next unless table
      next unless table.css('tr').size == 3 || table.css('td').size == 3

      title = doc.document.create_element('h4')
      title.inner_html = table.css('td')[0].inner_html

      footer = doc.document.create_element('div', class: 'c-cg-task__copyright')
      footer.inner_html = table.css('td')[2].inner_html

      body = process_task_body(table.css('td')[1], with_break: with_break)

      panel = doc.document.create_element('div', class: 'callout success')
      panel << title
      panel << body
      panel << footer

      table.replace(panel)
    end
  end

  def realign_tables
    doc.css('table').each do |table|
      style = table[:style].gsub(/margin-(left|right):[^;]+;?/, '') rescue nil
      table[:style] = "margin-left:auto;margin-right:auto;#{style}"
    end
  end

  def replace_guide_links
    doc.css('a[href*="docs.google.com/document/d/"]').each do |a|
      file_id = ContentGuide.file_id_from_url(a[:href])
      if (content_guide = ContentGuide.find_by_file_id(file_id))
        a.content = content_guide.name if a.text == a[:href]
        a[:href] = content_guide_url(content_guide)
      end
    end
  end

  def wrap_keywords(content)
    result = content.dup

    keywords = ContentGuideDefinition.all.map { |d| [d.keyword, d.description] }

    ContentGuideStandard.all.each do |standard|
      keywords << [standard.name, standard.description]
    end

    keywords.each do |keyword, value|
      value.gsub!('"', '&quot;')
      node = %Q(<span data-tooltip title="#{value}">#{keyword}</span>)
      result.gsub!(/(>|\s)#{keyword}(\.\W|[^.\w])/i) { |m| m.gsub!(keyword, node) }
    end

    result
  end

  protected

  def init_doc
    html = @wrap_keywords ? wrap_keywords(content) : content
    @doc = Nokogiri::HTML.fragment(html)
    embed_audios
    embed_videos
    process_blockquotes
    process_footnote_links
    process_tasks
    realign_tables
    replace_guide_links
  end
end
