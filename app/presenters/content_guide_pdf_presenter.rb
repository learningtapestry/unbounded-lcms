class ContentGuidePdfPresenter < ContentGuidePresenter
  FOOTNOTES_CLASS = 'contengGuide__footnotes'

  def initialize(content_guide, host, view_context, wrap_keywords = false)
    super(content_guide, host, view_context, wrap_keywords)
  end

  def footer_title
    "#{subject.try(:upcase)} #{grades_title} #{title}"
  end

  def header_title
    "#{subject.try(:upcase)} #{grades_title}"
  end

  private

  def grades_title
    first_grade = grade_list.first.try(:titleize)
    return first_grade if grade_list.size < 2
    "#{first_grade}-#{grade_list.last[/\d+/]}"
  end

  def mark_footnotes
    if (hr = doc.at_xpath('hr[following-sibling::div[.//a[starts-with(@id, "ftnt")]]]'))
      hr[:class] = FOOTNOTES_CLASS
    end
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
    doc.css("[style]").each do |node|
      node.remove_attribute('style')
    end
  end

  def wrap_keywords(content)
    result = content.dup
    result.gsub!(/[[:alnum:]]+(\.[[:alnum:]]+)+/) do |m|
      if (standard = CommonCoreStandard.find_by_name_or_synonym(m))
        toggler = "<span class=c-cg-keyword>"
        if (emphasis = standard.emphasis)
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


  protected

  def process_content
    @wrap_keywords ? wrap_keywords(content) : content
  end

  def process_doc
    mark_footnotes
    process_annotation_boxes
    process_blockquotes
    process_broken_images
    process_footnote_links
    process_footnotes
    process_icons
    process_pullquotes
    process_superscript_standards
    process_standards_table
    process_tasks(with_break: false)
    remove_comments
    replace_guide_links
    replace_image_sources
    reset_heading_styles
    reset_table_styles
    #reset_styles
  end
end
