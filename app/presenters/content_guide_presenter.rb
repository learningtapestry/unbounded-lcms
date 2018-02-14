# frozen_string_literal: true

require 'securerandom'

class ContentGuidePresenter < BasePresenter # rubocop:disable Metrics/ClassLength
  include Rails.application.routes.url_helpers

  ANNOTATION_COLOR = '#fff2cc'

  DanglingLink = Struct.new(:text, :url)
  Heading = Struct.new(:anchor, :children, :level, :text)

  attr_reader :host, :view_context

  def initialize(content_guide, host = nil, view_context = nil, wrap_keywords: false)
    super(content_guide)

    default_url_options[:host] = host
    @host = host
    @view_context = view_context
    @wrap_keywords = wrap_keywords
  end

  def self.ccss_standards
    @ccss_standards ||= CommonCoreStandard.pluck(:alt_names, :name).flatten.uniq
  end

  def sticky_title
    "#{t('ui.unbounded')} #{subject} #{t('ui.guide')} #{grades.range}"
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

    headings = []

    doc.css('h1, h2, h3').each_with_index.map do |h, i|
      id = "heading_#{i}"
      text = h.text.chomp.strip

      h[:class] = 'c-cg-heading'
      h[:id] = id

      level = h.name.tr('h', '')
      heading = Heading.new(id, [], level, text)

      # TODO: find a better way to organize this
      if headings.any?
        case h.name
        when 'h2'
          parent = headings.last
          next unless parent
          parent.children ||= []
          parent.children << heading
        when 'h3'
          parent = headings.last.children.last rescue nil
          next unless parent
          parent.children ||= []
          parent.children << heading
        else headings << heading
        end
      else
        headings << heading
      end
    end

    headings
  end

  def faq_ref
    # below we force headings to process and genearete ids, in case caching is enabled
    # https://github.com/learningtapestry/unbounded/issues/822
    headings unless @doc_processed
    doc.css('h1.c-cg-heading').last.try(:attr, 'id')
  end

  def html
    Rails.cache.fetch("content_guides:#{id}") do
      process_doc
      doc.to_s.html_safe
    end
  end

  def icons
    find_custom_tags('icon') + find_custom_tags('icon-small')
  end

  def podcast_links
    media_links(tag: 'podcast', url_selector: 'a[href*="soundcloud.com"]')
  end

  def tasks_without_break
    @tasks_without_break ||= begin
      tasks = find_custom_tags('task').map { |tag| next_element_with_name(tag.parent, 'table') }
      tasks.compact.select do |table|
        find_custom_tags('task break', table).empty? && find_custom_tags('no task break', table).empty?
      end
    end
  end

  def video_links
    media_links(tag: 'video', url_selector: 'a[href*="youtu"]')
  end

  def internal_links
    concatenate_splitted_spans('link')
    find_custom_tags('link')
  end

  def broken_ext_links
    broken_links = []
    find_custom_tags('link-to') do |tag|
      link_data = tag.attr('data-value')
      /(?:doc:)(.+)(?:anchor:)(.+)(?:value:)(.+)/.match(link_data) do |m|
        tag_permalink = m[1].strip
        broken_links << tag_permalink unless ContentGuide.find_by_permalink(tag_permalink)
      end
    end
    broken_links # List of broken permalinks
  end

  def internal_links_refs
    internal_links.map { |t| quoted_attribute(t, 'name') }.compact.uniq
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

  def create_media_node(resource, container, opts = {})
    opts = {
      base_class: 'c-cg-media',
      start_time: nil,
      stop_time: nil,
      with_description: false
    }.merge(opts)

    title = doc.document.create_element('a',
                                        class: "#{opts[:base_class]}__title",
                                        href: media_path(resource),
                                        target: '_blank')
    title.content = resource.title

    media = doc.document.create_element('div', class: opts[:base_class])
    media.set_attribute('data-start', opts[:start_time]) if opts[:start_time]
    media.set_attribute('data-stop', opts[:stop_time]) if opts[:stop_time]
    media << title
    media << container

    if opts[:with_description]
      description = doc.document.create_element('div', class: "#{opts[:base_class]}__description")
      description.inner_html = resource.description
      media << description
    end

    media
  end

  def doc
    @doc ||= Nokogiri::HTML.fragment(process_content.tr("\u00a0", ' '))
  end

  def embed_audios
    podcast_links.each_with_index do |a, index|
      url = a[:href]
      resource = Resource.find_podcast_by_url(url)
      next unless resource

      embed_info = MediaEmbed.soundcloud(url, try(:subject).try(:to_sym))
      next unless embed_info.present?

      container = doc.document.create_element('div', id: "sc_container_#{index}", class: 'c-cg-media__podcast')
      container << embed_info
      media = create_media_node(resource, container, start_time: a[:start], stop_time: a[:stop])

      a.replace(media)
    end
  end

  def embed_videos
    video_links.each do |a|
      url = a[:href]
      resource = Resource.find_video_by_url(url)
      next unless resource

      video_id = MediaEmbed.video_id(url)
      url_params = {}
      url_params[:start] = a[:start] if a[:start].present?
      url_params[:end] = a[:stop] if a[:stop].present?

      query = url_params.present? ? "?#{url_params.to_query}" : ''
      src = "https://www.youtube.com/embed/#{video_id}#{query}"

      container = doc.document.create_element('div', class: 'o-media-video')
      container << doc.document.create_element('iframe', allowfullscreen: nil, frameborder: 0,
                                                         height: 315, src: src, width: 560)
      media = create_media_node(resource, container, base_class: 'c-cg-video', with_description: true)
      media['id'] = ERB::Util.url_encode(a[:id].parameterize) if a[:id].present?

      a.replace(media)
    end
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def find_custom_tags(tag_name, node = nil, &block)
    tag_regex = /<#{tag_name}(:?[^->]*)?>/i
    bold_regex = /font-weight:\s*(bold|[5-9]00)/
    (node || doc).css('span').map do |span|
      next unless (span[:style] || '') =~ bold_regex

      content = span.content

      next unless content =~ tag_regex

      tag_def = content[tag_regex]
      before, after =
        content.split(tag_def).map do |tag_content|
          next unless tag_content.present?
          new_span = doc.document.create_element('span', style: span[:style])
          new_span.content = tag_content
          new_span
        end

      span.after(after) if after
      span.before(before) if before
      span.content = tag_def

      if tag_name == 'link-to' # not sure if that acceptable for other tags
        _, *tag_value = tag_def.split(':')
        tag_value = tag_value.join(':')
      else
        _, tag_value = tag_def.split(':')
      end
      span['data-value'] = tag_value.strip.delete('>') rescue nil

      yield span if block
      span
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
      next unless table&.xpath('tbody/tr/td')&.size == 1

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

    find_custom_tags('annotation', table).map.with_index do |tag, index| # rubocop:disable Metrics/BlockLength
      id = "annotation_#{SecureRandom.hex(4)}"

      annotation = doc.document.create_element('span', class: 'c-cg-annotation')
      annotation << doc.document.create_element('span', (index + 1).to_s, class: 'c-cg-annotationBox__number',
                                                                          'data-toggle' => id)
      prev_element = tag.previous
      loop do
        break unless prev_element && prev_element[:style] =~ background_color_regex

        current_element = prev_element
        prev_element = current_element.previous
        current_element[:style] = current_element[:style].gsub(background_color_regex, '')
        annotation << current_element
      end

      dropdown = doc.document.create_element('span', class: 'c-cg-dropdown dropdown-pane', id: id,
                                                     'data-dropdown' => nil, 'data-hover' => true,
                                                     'data-hover-delay' => 0, 'data-hover-pane' => true)
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
      return unless table&.css('td')&.size == 1

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
      a['class'] = 'c-cg-sup'
      a.inner_html = a.inner_html[/\d+/] || a.inner_html
      dropdown = doc.document.create_element('span', class: 'dropdown-pane c-cg-dropdown', 'data-dropdown' => true,
                                                     'data-hover' => true, 'data-hover-delay' => 0,
                                                     'data-hover-pane' => true, id: id)
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

    h_endnote = doc.document.create_element('h1')
    h_endnote.inner_html = t('content_guides.show.endnotes')
    hr.replace h_endnote
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
      return unless table&.css('td')&.size == 1

      cell = table.at_css('td')
      pullquote = doc.document.create_element('div', class: 'c-cg-pullquote')
      pullquote.content = cell.content
      table.replace(pullquote)
    end
  end

  def process_superscript_standards
    superscripts = Set.new
    superscript_style = /vertical-align:\s*super;?/
    doc.css('.c-cg-keyword').each do |span|
      superscript_ancestor = span.ancestors.find do |node|
        (node[:style] || '') =~ superscript_style
      end
      superscripts << superscript_ancestor if superscript_ancestor
    end
    superscripts.each do |superscript|
      superscript.inner_html = " (#{superscript.inner_html})"
      superscript[:style] = superscript[:style].gsub(superscript_style, '')
    end
  end

  def process_standards_table(force_border: false)
    find_custom_tags('standards').each do |tag|
      table = next_element_with_name(tag.parent, 'table')
      tag.remove
      return unless table # rubocop:disable Lint/NonLocalExitFromIterator

      has_standards = force_border
      table.css('[data-toggle]').each do |dropdown|
        dropdown.delete('data-toggle')
        has_standards = true
      end

      add_css_class(table, 'c-cg-table--left-border') if has_standards
    end
  end

  def process_task_body(table, with_break:) # rubocop:disable Metrics/AbcSize
    body = doc.document.create_element('div', class: 'c-cg-task__body')
    body.inner_html = table.xpath('tbody/tr/td')[1].inner_html

    parts = [body]

    if (tag = find_custom_tags('task break', body).first)
      tag = tag.parent
      if with_break
        if (next_node = tag.next)
          hidden = doc.document.create_element('div', class: 'c-cg-task__hidden')
          loop do
            break unless next_node # rubocop:disable Metrics/BlockNesting
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

    if (copyright_row = table.xpath('tbody/tr/td')[2]).content.strip.size.positive?
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

  def process_links
    find_custom_tags('link-to') do |tag|
      link_data = tag.attr('data-value')
      /(?:doc\:)(.+)(?:anchor\:)(.+)(?:value\:)(.+)/.match(link_data) do |m|
        tag_permalink, tag_anchor, tag_description = m.to_a[1..3].map(&:strip)
        tag_anchor = ERB::Util.url_encode(tag_anchor.parameterize)
        target = '_blank'
        if permalink == tag_permalink # Anchor is on the same page
          path = "##{tag_anchor}"
          target = nil
        else
          content_guide = ContentGuide.find_by_permalink(tag_permalink)
          next unless content_guide
          path = content_guide_path(content_guide.permalink, content_guide.slug, anchor: tag_anchor)
        end
        link = doc.document.create_element('a', class: 'c-cg-link', href: path, target: target)
        link << tag_description
        tag.replace(link)
      end
    end
  end

  def process_anchors
    find_custom_tags('anchor') do |tag|
      target = tag.attr('data-value')
      if target.present?
        target = ERB::Util.url_encode(target.parameterize)
        anchor = doc.document.create_element('a', id: target)
        tag.replace(anchor)
      end
    end
  end

  def process_internal_links
    internal_links.each do |tag|
      target = quoted_attribute(tag, 'name')
      next if target.blank?

      contents = quoted_attribute(tag, 'value') || target
      anchor = doc.document.create_element('a', contents, href: "##{ERB::Util.url_encode(target.parameterize)}")
      tag.replace(anchor)
    end
  end

  def remove_comments
    doc.css('[id^=cmnt]').each do |a|
      begin
        a.ancestors('sup').first.remove
      rescue StandardError
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
        add_css_class(table, 'c-cg-single-cell-table')
        # remove inline borders style with width = 0 as they're not processing correct for pdf
        table.xpath('tbody/tr/td').each do |node|
          node_style = (node[:style] || '')
          node_style.scan(/border-\w+-width:\s*0\w+;?/).each do |m|
            border_type = m[/-\w+-/]
            %w(width color style').each do |border_style|
              node[:style] = node[:style].gsub(/border#{border_type}#{border_style}:\s*[\#\w]+;?\s*/i, '')
            end
          end
        end
        next
      end

      table[:class] = 'c-cg-table'
      table.remove_attribute('style')
      # keep all styled for subelements except border styles (have them redifined at css)
      table.xpath('tbody/tr | tbody/tr/td').each do |node|
        node[:style] = node[:style].gsub(/border[\w\-]+:\s*[\w#]+;?\s*/i, '') if node[:style].present?
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

        dropdowns << %(
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

    result.gsub!(/[[:alnum:]]+([.-][[:alnum:]]+)+/) do |m|
      if standard?(m) && (standard = CommonCoreStandard.find_by_name_or_synonym(m)) &&
         standard.description.present?

        id = "cg-k_#{SecureRandom.hex(4)}"

        # If the dropdown-pane doesn't have a toggler element, the plugin
        # will throw an exception during initialization.
        # For some standard references we're removing the dropdown behavior
        # because that's undesirable, thus prompting this exception.
        # Add a hidden toggle button that is always present, so this doesn't happen.
        dropdowns << %(
          <span class=hide data-toggle=#{id}></span>
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
        if (emphasis = standard.emphasis(grades.list.first))
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

  def wrap_tables
    margin_left_right_regex = /margin-\w+t:\s*[\w.]+;?\s*/i
    doc.css('table').each do |table|
      next if table.ancestors('.c-cg-scroll-wrap').present?
      wrap_style = ''
      # move margin-left/right styles to the wrapper to make possible to set table width as 100%
      table[:style] = (table[:style] || '').gsub(margin_left_right_regex) do |m|
        wrap_style += m
        ''
      end
      wrap = doc.document.create_element('div', class: 'c-cg-scroll-wrap', style: wrap_style)
      table.replace(wrap)
      wrap << table
    end
  end

  def remove_default_color
    doc.css('p, p span').each do |p|
      next unless p[:style].present?
      p[:style] = p[:style].gsub(/;\s*color:\s*[#0]+\s*(;|$)/, ';')
      p[:style] = p[:style].gsub(/^\s*color:\s*[#0]+\s*(;|$)/, '')
    end
  end

  def remove_style_nodes
    # remove inlined style elements from gdoc html
    doc.css('style').each(&:remove)
  end

  def concatenate_spans
    span_meaning_styles_regex = /(text-decoration|display|width|font-style|font-weight|color)/
    remove_default_color
    doc.css('p span').each do |span|
      # remove excessive spans
      if span[:class].blank? && (span[:style] =~ span_meaning_styles_regex).nil?
        span.replace(span.inner_html)
      elsif span[:style].present?
        # change height to auto, critical for responsive, especially if subelement is image
        span[:style] = span[:style].gsub(/height:\s*[\w.]+;?\s*/i, 'height:auto;')
        span[:style] = span[:style].gsub(/width:\s*[\w.]+;?\s*/i, 'width:auto;') if span.xpath('./img').present?
      end
    end
  end

  protected

  def media_attribute(media, tag)
    media.content.match(/#{tag}=.?\d+/).to_s[/\d+/]
  end

  def quoted_attribute(value, tag)
    /(?:#{tag}\s*=\s*[”"'])([^”"']+)(?:[”"'])/.match(value.content) do |m|
      return m[1]
    end
  end

  def concatenate_splitted_spans(tag)
    # need to concatenate media tags that gdoc splitted into several spans
    doc.css("p span:contains('<#{tag}')").each do |node|
      next unless !node.content.include?('>') && (node[:style] || '') =~ /font-weight:\s*(bold|[5-9]00)/
      node.parent.css('span').each_with_index do |span, idx|
        next if idx.zero?
        node.inner_html += span.inner_html.to_s
        span.remove
        break if span.content.include?('>')
      end
    end
  end

  def media_links(tag:, url_selector:)
    concatenate_splitted_spans(tag)
    find_custom_tags(tag).map do |media|
      start_time = media_attribute(media, :start)
      stop_time = media_attribute(media, :stop)
      id = quoted_attribute(media, :name)
      s_link = next_element_with_name(media.parent, 'p')
      media.remove
      next unless s_link.present?
      s_link = s_link.css(url_selector).try(:first)
      next unless s_link.present?
      s_link.set_attribute('start', start_time) if start_time
      s_link.set_attribute('stop', stop_time) if stop_time
      s_link.set_attribute('id', id) if id
      s_link
    end.compact
  end

  def add_css_class(el, *classes)
    existing = (el[:class] || '').split(/\s+/)
    el[:class] = existing.concat(classes).uniq.join(' ')
  end

  def process_content
    content_ext = content + (faq.try(:description) || '')
    @wrap_keywords ? wrap_keywords(content_ext) : content_ext
  end

  def process_doc
    # return if @doc_processed

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
    process_links
    process_anchors
    process_internal_links
    remove_comments
    replace_guide_links
    reset_heading_styles
    reset_table_styles
    wrap_tables
    concatenate_spans
    remove_style_nodes

    @doc_processed = true
  end

  def standard?(str)
    self.class.ccss_standards.include?(str.downcase)
  end
end
