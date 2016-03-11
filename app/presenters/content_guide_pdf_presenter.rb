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

  protected

  def init_doc
    @doc = Nokogiri::HTML.fragment(content)
    mark_footnotes
    process_blockquotes
    process_tasks(with_break: false)
    realign_tables
    replace_guide_links
    replace_image_sources
  end
end
