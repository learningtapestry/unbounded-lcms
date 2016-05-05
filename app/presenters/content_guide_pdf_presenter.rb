class ContentGuidePdfPresenter < ContentGuidePresenter
  FOOTNOTES_CLASS = 'contengGuide__footnotes'

  def initialize(content_guide, host, view_context)
    super(content_guide, host, view_context, wrap_keywords: false)
  end

  private

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

  protected

  def process_content
    content
  end

  def process_doc
    mark_footnotes
    process_annotation_boxes
    process_blockquotes
    process_tasks(with_break: false)
    replace_guide_links
    replace_image_sources
    reset_table_styles
    process_icons
    process_standards
    process_pullquotes
    reset_styles
  end
end
