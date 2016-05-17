require 'securerandom'

class ContentGuidePresenter < BasePresenter
  include Rails.application.routes.url_helpers

  ANNOTATION_COLOR = '#fff2cc'

  DanglingLink = Struct.new(:text, :url)
  Heading = Struct.new(:id, :level, :text)

  attr_reader :doc, :host, :view_context

  def initialize(content_guide, host = nil, view_context = nil, wrap_keywords: false)
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
    doc.css('a[href*="docs.google.com/document/d/"]').map do |a|
      file_id = ContentGuide.file_id_from_url(a[:href])
      next unless file_id.present?

      DanglingLink.new(a.text, a[:href]) unless ContentGuide.exists?(file_id: file_id)
    end.compact
  end

  def headings
    process_doc

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

  def html
    process_doc
    doc.to_s.html_safe
  end

  def icons
    find_custom_tags('icon') + find_custom_tags('icon-small')
  end

  def podcast_links
    doc.css('a[href*="soundcloud.com"]')
  end

  def tasks_without_break
    @tasks_without_break ||= begin
      find_custom_tags('task').map do |tag| 
        next_element_with_name(tag.parent, 'table')
      end.compact.select do |table|
        find_custom_tags('task break', table).empty? &&
          find_custom_tags('no task break', table).empty?
      end
    end
  end

  def video_links
    doc.css('a[href*="youtube.com/watch?"]')
  end

  private

  def all_next_elements_with_name(tag, name)
    nodes = []
    next_node = tag.try(:next)

    loop do
      break if next_node.nil?
      nodes << next_node if next_node.name == name
      next_node = next_node.next
    end

    nodes
  end

  def create_media_node(resource, container)
    title = doc.document.create_element('a', class: 'c-cg-media__title', href: media_path(resource), target: '_blank')
    title.content = resource.title

    media = doc.document.create_element('div', class: 'c-cg-media')
    media << title
    media << container

    media
  end

  def doc
    @doc ||= Nokogiri::HTML.fragment(process_content)
  end

  def embed_audios
    urls_hash = {}

    podcast_links.each_with_index do |a, index|
      url = a[:href]
      resource = Resource.find_podcast_by_url(url)
      next unless resource

      id = "sc_container_#{index}"
      urls_hash[id] = url

      container = doc.document.create_element('div', id: id)
      media = create_media_node(resource, container)

      a.replace(media)
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
    video_links.each do |a|
      url = URI(a[:href])
      resource = Resource.find_video_by_url(url)
      next unless resource

      params = Rack::Utils.parse_query(url.query)
      video_id = params['v']
      src = "https://www.youtube.com/embed/#{video_id}"
      iframe = doc.document.create_element('iframe', allowfullscreen: nil, frameborder: 0, height: 315, src: src, width: 560)

      media = create_media_node(resource, iframe)

      a.replace(media)
    end
  end

  def find_custom_tags(tag_name, node = nil, &block)
    (node || doc).css('span').map do |span|
      if (span[:style] || '') =~ /font-weight:\s*bold/
        content = span.content
        tag_regex = /<#{tag_name}(:?[^->]*)?>/i

        if content =~ tag_regex
          tag_def = content[tag_regex]
          before, after =
            content.split(tag_def).map do |content|
              next unless content.present?
              new_span = doc.document.create_element('span', style: span[:style])
              new_span.content = content
              new_span
            end

          span.after(after) if after
          span.before(before) if before
          span.content = tag_def

          _, tag_value = tag_def.split(':')
          span['data-value'] = tag_value.strip.gsub('>', '') rescue nil

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
    find_custom_tags('annotation').map { |tag| tag.ancestors('table').first }.compact.uniq.each do |table|
      next unless table && table.xpath('tbody/tr/td').size == 1

      annotation_dropdowns = process_annotations(table)

      annotation_box = doc.document.create_element('div', class: 'c-cg-annotationBox')
      annotation_box.inner_html = table.at_css('td').inner_html

      annotation_list = doc.document.create_element('div', class: 'c-cg-annotationList')
      annotation_dropdowns.each_with_index do |dropdown, index|
        number = doc.document.create_element('span', class: 'c-cg-annotationListItem__number')
        number.content = index + 1

        content = doc.document.create_element('span', class: 'c-cg-annotationListItem__content')
        content.inner_html = dropdown.inner_html

        list_item = doc.document.create_element('p', class: 'c-cg-annotationListItem')
        list_item << number
        list_item << content

        annotation_list << list_item
      end

      table.replace(annotation_box)
      annotation_box.next = annotation_list
    end
  end

  def process_annotations(table)
    background_color_regex = /background-color:\s*#{ANNOTATION_COLOR};?\s*/

    find_custom_tags('annotation', table).map do |tag|
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

      dropdown = doc.document.create_element('span', class: 'c-cg-dropdown dropdown-pane', id: id, 'data-dropdown' => nil, 'data-hover' => true, 'data-hover-delay' => 0, 'data-hover-pane' => true)
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
      return unless table && table.css('td').size == 1

      blockquote = doc.document.create_element('div', class: 'c-cg-blockquote')
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
      dropdown = doc.document.create_element('span', class: 'dropdown-pane c-cg-dropdown', 'data-dropdown' => true, 'data-hover' => true, 'data-hover-delay' => 0, 'data-hover-pane' => true, id: id)
      dropdown.inner_html = footnote.at_css('p').inner_html
      dropdown.at_css(a[:href]).remove
      dropdown.css('[data-toggle]').each do |toggler|
        toggler[:class] = nil
        toggler[:id] = nil
        toggler.delete('data-toggle')
      end
      a.parent.next = dropdown
    end
  end

  def process_footnotes
    hr = doc.at_css('hr')
    return unless hr

    all_next_elements_with_name(hr, 'div').each do |div|
      div[:class] = 'c-cg-footnote'
    end
  end

  def process_icons
    find_custom_tags('icon').each do |tag|
      icon_type = tag['data-value']
      span = doc.document.create_element('span', class: "c-cg-icon c-cg-icon--#{icon_type}")
      tag.replace(span)
    end

    find_custom_tags('icon-small').each do |tag|
      icon_type = tag['data-value']
      span = doc.document.create_element('span', class: "c-cg-icon-small c-cg-icon--#{icon_type}")
      tag.replace(span)
    end
  end

  def process_pullquotes
    find_custom_tags('pullquote') do |tag|
      table = next_element_with_name(tag.parent, 'table')
      tag.remove
      return unless table && table.css('td').size == 1

      cell = table.at_css('td')
      pullquote = doc.document.create_element('div', class: 'c-cg-pullquote')
      pullquote.content = cell.content
      table.replace(pullquote)
    end
  end

  def process_superscript_standards
    superscript_style = /vertical-align:\s*super;?/
    doc.css('.c-cg-keyword').each do |span|
      superscript_ancestor = span.ancestors.find do |node|
        (node[:style] || '') =~ superscript_style
      end
      if superscript_ancestor
        span.inner_html = "(#{span.inner_html})"
        superscript_ancestor[:style] = superscript_ancestor[:style].gsub(superscript_style, '')
        superscript_ancestor.inner_html = " #{superscript_ancestor.inner_html}"
      end
    end
  end

  def process_standards_table
    find_custom_tags('standards').each do |tag|
      table = next_element_with_name(tag.parent, 'table')
      tag.remove
      return unless table

      table.css('[data-toggle]').each do |dropdown|
        dropdown.delete('data-toggle')
      end
    end
  end

  def process_task_body(table, with_break:)
    body = doc.document.create_element('div', class: 'c-cg-task__body')
    body.inner_html = table.xpath('tbody/tr/td')[1].inner_html

    parts = [body]

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
          body << hidden
        end

        hide_task = doc.document.create_element('span', class: 'c-cg-task__toggler__hide')
        hide_task.content = t('ui.hide')

        show_task = doc.document.create_element('span', class: 'c-cg-task__toggler__show')
        show_task.content = t('ui.show')

        toggler = doc.document.create_element('div', class: 'c-cg-task__toggler')
        toggler << hide_task
        toggler << show_task

        parts << toggler
      end

      tag.remove
    end

    if (copyright_row = table.xpath('tbody/tr/td')[2]).content.strip.size > 0
      copyright = doc.document.create_element('p', class: 'c-cg-task__copyright')
      copyright.inner_html = copyright_row.inner_html
      body << copyright
    end

    parts
  end

  def process_tasks(with_break: true)
    find_custom_tags('task') do |tag|
      table = next_element_with_name(tag.parent, 'table')
      tag.remove
      next unless table
      next unless table.xpath('tbody/tr').size == 3 || table.css('tbody/tr/td').size == 3

      title = doc.document.create_element('h4', class: 'c-cg-task__title')
      title.content = table.xpath('tbody/tr/td')[0].content

      body, toggler = process_task_body(table, with_break: with_break)

      task = doc.document.create_element('div', class: 'c-cg-task')
      task << title
      task << body
      task << toggler if toggler

      table.replace(task)
    end
  end

  def remove_comments
    doc.css('[id^=cmnt]').each do |a|
      begin
        a.ancestors('sup').first.remove
      rescue
        a.ancestors('div').first.remove
      end
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

  def reset_heading_styles
    doc.css('h1, h2, h3, h4').each do |h|
      h.remove_attribute('style')
      h.css('*').each do |n|
        n.remove_attribute('style')
      end
    end
  end

  def reset_table_styles
    doc.css('table').each do |table|
      if table.xpath('tbody/tr/td').size == 1
        table[:class] = 'c-cg-single-cell-table'
        next
      end

      table[:class] = 'c-cg-table'
      table.remove_attribute('style')
      table.xpath('tbody/tr | tbody/tr/td').each do |node|
        node.remove_attribute('style')
      end
    end
  end

  def wrap_keywords(content)
    result = content.dup

    defintions = {}
    ContentGuideDefinition.find_each { |d| defintions[d.keyword] = d.description }

    dropdowns = []
    defintions.each do |keyword, description|
      next unless description.present?

      result.gsub!(/(>|\(|\s)#{keyword}(\.\W|[^.\w])/i) do |m|
        id = "cg-k_#{SecureRandom.hex(4)}"

        dropdowns << %Q(
          <span class='dropdown-pane c-cg-dropdown'
                data-dropdown
                data-hover=true
                data-hover-delay=0
                data-hover-pane=true
                id=#{id}>
            #{description}
          </span>
        )

        toggler = "<span class=c-cg-keyword data-toggle=#{id}>#{keyword}</span>"
        m.gsub!(/#{keyword}/i, toggler)
      end
    end

    result.gsub!(/[[:alnum:]]+(\.[[:alnum:]]+)+/) do |m|
      if (standard = CommonCoreStandard.find_by_name_or_synonym(m))
        id = "cg-k_#{SecureRandom.hex(4)}"
        dropdowns << %Q(
          <span class='dropdown-pane c-cg-dropdown'
                data-dropdown
                data-hover=true
                data-hover-delay=0
                data-hover-pane=true
                id=#{id}>
            #{standard.description}
          </span>
        )
        toggler = "<span class=c-cg-keyword data-toggle=#{id}>"
        if (emphasis = standard.emphasis)
          toggler += "<span class='c-cg-standard c-cg-standard--#{emphasis}' />"
        end
        toggler += "#{m}</span>"
        toggler
      else
        m
      end
    end

    result + dropdowns.join
  end

  protected

  def process_content
    @wrap_keywords ? wrap_keywords(content) : content
  end

  def process_doc
    return if @doc_processed

    embed_audios
    embed_videos
    process_annotation_boxes
    process_blockquotes
    process_broken_images
    process_footnote_links
    process_footnotes
    process_icons
    process_pullquotes
    process_superscript_standards
    process_standards_table
    process_tasks
    remove_comments
    replace_guide_links
    reset_heading_styles
    reset_table_styles
    @doc_processed = true
  end
end
