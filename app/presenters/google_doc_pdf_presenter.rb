class GoogleDocPdfPresenter < GoogleDocPresenter
  FOOTNOTES_CLASS = 'googleDoc__footnotes'

  def initialize(google_doc, host, view_context)
    super(google_doc, host, view_context, wrap_keywords: false)
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
    process_stars
    process_tasks
    realign_tables
    replace_guide_links
    replace_image_sources
  end
end
