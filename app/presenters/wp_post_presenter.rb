class WPPostPresenter < SimpleDelegator
  EXCERPT_SIZE = 200
  MEDIA_SIZE = 'card_post_1x'.freeze

  def author
    embedded['author'][0]['name'] if author?
  end

  def author?
    embedded.key?('author') && embedded['author'].present?
  end

  def autor_dsc
    embedded['author'][0]['description'] if author?
  end

  def category
    embedded['wp:term'][0][0]['name'] if category?
  end

  def category?
    embedded.key?('wp:term') && embedded['wp:term'].present? && embedded['wp:term'].first.present?
  end

  def date
    self['date_gmt'].to_date.strftime('%^B %d, %Y')
  end

  def excerpt
    h.truncate_html(self['excerpt']['rendered'], length: EXCERPT_SIZE)
  end

  def permalink
    self['link']
  end

  def thumbnail
    sizes = embedded['wp:featuredmedia'][0]['media_details']['sizes']
    url = sizes.key?(MEDIA_SIZE) ? sizes[MEDIA_SIZE] : sizes['thumbnail']
    url['source_url']
  end

  def thumbnail?
    embedded['wp:featuredmedia'].present?
  end

  def title
    self['title']['rendered']
  end

  private

  def embedded
    self['_embedded']
  end

  def h
    ApplicationController.helpers
  end
end
