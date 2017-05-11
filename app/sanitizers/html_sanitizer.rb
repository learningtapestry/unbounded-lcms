class HtmlSanitizer
  class << self
    def sanitize(html)
      Sanitize.fragment(html, default_config)
    end

    def default_config
      {
        elements: %w(table td th tr tbody thead span a p h1 h2 h3 h4 h5 h6 ol ul li div img hr abbr b blockquote br cite code dd dfn dl dt em i kbd mark pre q s samp small strike strong sub sup time u var),
        attributes: {
          'a'    => %w(href title data-toggle id),
          'img'  => %w(src alt),
          'ol'   => %w(type style start),
          'ul'   => %w(type style start),
          'p'    => %w(style),
          'span' => %w(style),
          'td'   => %w(colspan rowspan),
          'th'   => %w(colspan rowspan)
        },
        protocols: {
          'a' => { 'href' => ['http', 'https', :relative] }
        },
        css: {
          properties: %w(list-style-type font-style text-decoration font-weight)
        },
        transformers: [ # These transformers Will be executed via .call(), as lambdas
          method(:remove_meanless_styles),
          method(:remove_empty_paragraphs),
          # TODO need to change parsing tags xpath before, it's relying on spans
          # method(:remove_spans_wo_attrs)
          method(:remove_gdocs_suggestions),
          method(:replace_charts_urls),
        ]
      }
    end

    private

    # Replace '<span>text</span>' with 'text'
    def remove_spans_wo_attrs(env)
      node = env[:node]
      if node.element? && node.name == 'span' && node.attr('style').blank?
        node.replace(node.inner_html)
      end
    end

    # Remove '<p></p>' or '<span></span>'
    def remove_empty_paragraphs(env)
      node = env[:node]
      if node.element? && (node.name == 'p' || node.name == 'span') && node.inner_html.blank?
        node.unlink
      end
    end

    def remove_meanless_styles(env)
      node = env[:node]
      if node.element? && node.attr('style').present?
        node['style'] = node['style'].gsub(/font-weight:\s*(normal|[1-4]00;?)/, '')
                                     .gsub(/font-style:\s*normal;?/, '')
                                     .gsub(/text-decoration:\s*none;?/, '')
      end
    end

    # Remove "color:#000000;" from inline styles
    def remove_black_color(env)
      node = env[:node]
      if node.element? && node.attr('style').present?
        node['style'] = node['style'].gsub(/(?<!background-)(color:#000000;?)/, '')
      end
    end

    def remove_gdocs_suggestions(env)
      node = env[:node]
      node.css('[id^=cmnt]').each do |a|
        begin
          a.ancestors('sup').first.remove
        rescue
          a.ancestors('div').first.remove
        end
      end
    end

    def replace_charts_urls(env)
      node = env[:node]
      node.css('img[src^="https://www.google.com/chart"]').each do |img|
        img[:src] = img[:src].gsub('www.google', 'chart.googleapis')
      end
    end
  end
end
