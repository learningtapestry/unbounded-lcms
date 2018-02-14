# frozen_string_literal: true

class ContentGuidePdfPresenter < ContentGuidePresenter
  FOOTNOTES_CLASS = 'contengGuide__footnotes'

  def initialize(content_guide, host, view_context, wrap_keywords = false)
    super(content_guide, host, view_context, wrap_keywords)
  end

  def footer_title
    title
  end

  def header_title
    "#{subject.try(:upcase)} #{grades_title}"
  end

  def html
    process_doc
    doc.to_s.html_safe
  end

  private

  def add_nobreak_to_heading
    h1 = doc.at_css('h1')
    return unless h1

    prev_node = h1.previous
    loop do
      break unless prev_node
      return if prev_node.text.present?

      prev_node = prev_node.previous
    end

    h1[:class] = 'nobreak'
  end

  def add_nobreak_to_tasks
    doc.css('.c-cg-task').each do |task|
      prev_node = task.previous

      loop do
        break unless prev_node

        if prev_node.name !~ /h(1|2|3|4|5|6)/
          break if prev_node.text.present?
        elsif prev_node.text.present?
          task[:class] = "#{task[:class]} nobreak"
          break
        end

        prev_node = prev_node.previous
      end
    end
  end

  def grades_title
    g = grades.range
    g.include?('k') ? g.titleize : "#{t('ui.grade')} #{g}"
  end

  def mark_footnotes
    hr = doc.at_xpath('hr[following-sibling::div[.//a[starts-with(@id, "ftnt")]]]')
    hr[:class] = FOOTNOTES_CLASS if hr.present?
  end

  def replace_image_sources
    path2public = Rails.root.join('public')

    doc.css('img[src^="/assets"]').each do |img|
      img[:src] = "file://#{path2public}#{img[:src]}"
    end

    doc.css('img[src^="/uploads"]').each do |img|
      img[:src] = "file://#{path2public}#{img[:src]}"
    end
  end

  def reset_styles
    doc.css('[style]').each do |node|
      node.remove_attribute('style')
    end
  end

  def wrap_keywords(content)
    result = content.dup
    result.gsub!(/[[:alnum:]]+(\.[[:alnum:]]+)+/) do |m|
      if (standard = CommonCoreStandard.find_by_name_or_synonym(m))
        toggler = '<span class=c-cg-keyword>'
        if (emphasis = standard.emphasis(grades.list.first))
          toggler += "<span class='c-cg-standard c-cg-standard--#{emphasis}' />"
        end
        toggler += "#{m}</span>"
        toggler
      else
        m
      end
    end
    result
  end

  def remove_media_tag(tag)
    concatenate_splitted_spans(tag)
    find_custom_tags(tag).each(&:remove)
  end

  def remove_media_tags
    podcast_links.each(&:remove)
    video_links.each(&:remove)
    remove_media_tag('podcast')
    remove_media_tag('video')
    remove_media_tag('link')
  end

  protected

  def process_content
    @wrap_keywords ? wrap_keywords(content) : content
  end

  def process_doc
    add_nobreak_to_heading
    mark_footnotes
    process_annotation_boxes
    process_blockquotes
    process_broken_images
    process_footnote_links
    process_footnotes
    process_icons
    process_pullquotes
    process_superscript_standards
    process_standards_table(force_border: true)
    process_tasks(with_break: false)
    add_nobreak_to_tasks
    remove_comments
    remove_media_tags
    replace_guide_links
    replace_image_sources
    reset_heading_styles
    reset_table_styles
    wrap_tables
    concatenate_spans
    remove_style_nodes
  end
end
