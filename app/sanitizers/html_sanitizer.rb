class HtmlSanitizer

  attr_accessor :config

  def initialize
    @config = default_config
  end

  def sanitize(html)
    Sanitize.fragment(html, @config)
  end

  def default_config
    {
      elements: %w(table td th tr tbody thead span a p h1 h2 h3 h4 h5 h6 ol ul li div img hr),
      attributes: {
        'a'    => %w(href title data-toggle id),
        'img'  => %w(src alt),
        'ol'   => %w(type style),
        'p'    => %w(style),
        'span' => %w(style),
        'td'   => %w(colspan rowspan),
        'th'   => %w(colspan rowspan),
      },
      protocols: {
        'a' => {'href' => ['http', 'https', :relative]},
      },
      css: {
        properties: %w(list-style-type font-style text-decoration text-align vertical-align color background-color font-weight),
      },
      transformers: [ # These transformers Will be executed via .call(), as lambdas
        method(:_remove_black_color),
        method(:_remove_empty_paragraphs),
        method(:_remove_spans_wo_attrs),
      ],
    }
  end

  # Replace '<span>text</span>' with 'text'
  private def _remove_spans_wo_attrs(env)
    node = env[:node]
    if node.element? && node.name == 'span' && node.attr('style').blank?
      node.replace Nokogiri::XML::Text.new(node.inner_html, node.document)
    end
  end

  # Remove '<p></p>'
  private def _remove_empty_paragraphs(env)
    node = env[:node]
    if node.element? && node.name == 'p' && node.inner_html.blank?
      node.unlink
    end
  end

  # Remove "color:#000000;" from inline styles
  private def _remove_black_color(env)
    node = env[:node]
    if node.element? && node.attr('style').present?
      node['style'] = node['style'].gsub(/(?<!background-)(color:#000000;?)/, '')
    end
  end

end

