require 'securerandom'

class ContentGuidePresenter < SimpleDelegator
  include Rails.application.routes.url_helpers

  ANNOTATION_COLOR = '#ffff00'

  DanglingLink = Struct.new(:text, :url)
  Heading = Struct.new(:id, :level, :text)

  attr_reader :host, :view_context

  def initialize(content_guide, host, view_context, wrap_keywords: false)
    super(content_guide)

    default_url_options[:host] = host
    @host = host
    @view_context = view_context
    @wrap_keywords = wrap_keywords
  end

  def broken_images
    @broken_images ||= doc.css('[src*="google.com"]')
  end

  def dangling_links
    cache('dangling_links') do
      doc.css('a[href*="docs.google.com/document/d/"]').map do |a|
        file_id = ContentGuide.file_id_from_url(a[:href])
        next unless file_id.present?

        DanglingLink.new(a.text, a[:href]) unless ContentGuide.exists?(file_id: file_id)
      end.compact
    end
  end

  def headings
    cache('headings') do
      headings =
        doc.css('h1, h2, h3').each_with_index.map do |h, i|
          id = "heading_#{i}"
          level = h.name[/\d/].to_i
          text = h.text.chomp.strip

          h[:id] = id
          h['data-magellan-target'] = id
        
          Heading.new(id, level, text)
        end

      min_level = headings.map(&:level).minmax.first
      headings.each { |h| h.level -= min_level }
      headings
    end
  end

  def html
    cache('html') { doc.to_s.html_safe }
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
        if span.content.downcase =~ /<#{tag_name}>/
          yield span if block
          span
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

  def process_annotation_boxes
    find_custom_tags('annotation').map { |tag| tag.ancestors('table').first }.compact.uniq.each do |table, index|
      next unless table && table.css('tr').size == 1 && table.css('td').size == 1

      annotation_dropdowns = process_annotations(table)

      annotation_box = doc.document.create_element('div', class: 'c-cg-annotationBox')
      annotation_box.inner_html = table.at_css('td').inner_html

      annotation_list = doc.document.create_element('div', class: 'c-cg-annotationList')
      annotation_dropdowns.each_with_index do |dropdown, index|
        number = doc.document.create_element('span', class: 'c-cg-annotationList__number')
        number.content = index + 1

        content = doc.document.create_element('span')
        content.inner_html = dropdown.inner_html

        list_item = doc.document.create_element('p')
        list_item << number
        list_item << content

        annotation_list << list_item
      end

      table.replace(annotation_box)
      annotation_box.next = annotation_list
    end
  end

  def process_annotations(table)
    background_color_regex = /background-color:\s*#ffff00;?\s*/

    find_custom_tags('annotation', table).each_with_index.map do |tag, index|
      id = "annotation_#{SecureRandom.hex(4)}"

      annotation = doc.document.create_element('span', class: 'c-cg-annotation', 'data-toggle' => id)
      prev_element = tag.previous
      loop do
        break unless prev_element && prev_element[:style] =~ background_color_regex

        current_element = prev_element
        prev_element = current_element.previous
        current_element[:style] = current_element[:style].gsub(background_color_regex, '')
        annotation << current_element
      end

      dropdown = doc.document.create_element('span', class: 'dropdown-pane', id: id, 'data-dropdown' => nil, 'data-hover' => true, 'data-hover-pane' => true)
      next_element = tag.next
      loop do
        break unless next_element && next_element[:style] =~ background_color_regex

        current_element = next_element
        next_element = current_element.next
        current_element[:style] = current_element[:style].gsub(background_color_regex, '')
        dropdown << current_element
      end

      tag.replace(annotation)
      annotation.next = dropdown
      dropdown
    end
  end

  def process_blockquotes
    find_custom_tags('blockquote') do |tag|
      table = next_element_with_name(tag.parent, 'table')
      tag.remove
      return unless table && table.css('td').size != 1

      blockquote = doc.document.create_element('blockquote')
      blockquote.inner_html = table.at_css('td').inner_html
      table.replace(blockquote)
    end
  end

  def process_broken_images
    broken_images.each do |img|
      img[:style] = 'border: 5px solid #f00'
    end
  end

  def process_footnote_links
    doc.css('a[href^="#ftnt"]:not([href^="#ftnt_ref"])').each_with_index do |a, i|
      id = "content_guide_footnote_#{i}"
      footnote = doc.at_css(a[:href]).ancestors('div').first
      a['data-toggle'] = id
      dropdown = doc.document.create_element('span', class: 'dropdown-pane c-cg-dropdown', 'data-dropdown' => true, 'data-hover' => true, 'data-hover-pane' => true, id: id)
      dropdown.inner_html = footnote.at_css('p').inner_html
      dropdown.at_css(a[:href]).remove
      a.parent.next = dropdown
    end
  end

  def process_pullquotes
    find_custom_tags('pullquote') do |tag|
      table = next_element_with_name(tag.parent, 'table')
      tag.remove
      return unless table && table.css('td').size == 1

      pullquote = doc.document.create_element('div')
      pullquote[:class] = 'c-cg-pullquote callout secondary'
      pullquote.inner_html = table.at_css('td').inner_html
      table.replace(pullquote)
    end
  end

  def process_standards
    find_custom_tags('standards').each do |tag|
      table = next_element_with_name(tag.parent, 'table')
      tag.remove
      return unless table

      table.css('[data-toggle]').each do |dropdown|
        dropdown.delete('data-toggle')
      end
    end
  end

  def process_task_body(cell, with_break:)
    body = doc.document.create_element('div', class: 'c-cg-task__body')
    body.inner_html = cell.inner_html

    if (tag = find_custom_tags('task break', body).first)
      tag = tag.parent
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
      table = next_element_with_name(tag.parent, 'table')
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

    keywords = {}
    ContentGuideDefinition.find_each { |d| keywords[d.keyword] = d.description }
    Standard.where.not(name: [nil, '']).each do |standard|
      keywords[standard.name.upcase] = standard.description
      standard.alt_names.each do |alt_name|
        keywords[alt_name.upcase] = standard.description
      end
    end

    keywords.each do |keyword, value|
      next unless value.present?

      result.gsub!(/(>|\s)#{keyword}(\.\W|[^.\w])/i) do |m|
        id = "cg-k_#{SecureRandom.hex(4)}"
        dropdown = %Q(
          <span data-toggle=#{id}>#{keyword}</span>
          <span class='dropdown-pane c-cg-dropdown'
            data-dropdown
            data-hover=true
            data-hover-pane=true
            id=#{id}>
            #{value}
          </span>
        )
        m.gsub!(keyword, dropdown)
      end
    end

    result
  end

  protected

  def doc
    @doc ||= begin
      @doc = Nokogiri::HTML.fragment(process_content)
      process_doc
      @doc
    end
  end

  def process_content
    @wrap_keywords ? wrap_keywords(content) : content
  end

  def process_doc
    embed_audios
    embed_videos
    process_annotation_boxes
    process_blockquotes
    process_broken_images
    process_footnote_links
    process_pullquotes
    process_standards
    process_tasks
    realign_tables
    replace_guide_links
  end

  def cache(key)
    Rails.cache.fetch("content_guides/presented/#{id}/#{key}") { yield }
  end
end
