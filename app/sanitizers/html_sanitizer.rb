class HtmlSanitizer
  class << self
    def sanitize(html)
      Sanitize.fragment(html, default_config)
    end

    def sanitize_css(css)
      Sanitize::CSS.stylesheet(css, css_config)
    end

    def post_processing(html, subject)
      nodes = Nokogiri::HTML.parse html

      # removes all style attributes allowed earlier
      %w(p span).each do |tag|
        nodes.xpath("//#{tag}").each do |node|
          next if node.ancestors('td').present?
          node['style'] = Sanitize::CSS.properties(node['style'], css_inline_config)
          node.delete('style') if node['style'].blank?
        end
      end

      # adjusts `class` attributes for all `ol` elements inside tables
      nodes.xpath('//table//ol').each { |ol| ol['class'] = 'c-ld-ol' }

      # wrap all images for match except those inside table
      # handle images that should be cropped
      post_processing_images(nodes) if subject.to_s.casecmp('math').zero?

      # add style to table for consistent view
      # wrap for horizontal scrolling on small screens
      nodes
        .css('table:not(.o-ld-columns-table)')
        .add_class('c-ld-table')
        .wrap('<div class="c-ld-table__wrap"></div>')

      nodes.to_html
    end

    # config to keep list-style-type bc gdoc is doing this trough content/counter
    def css_config
      {
        css: {
          properties: %w(content counter-increment counter-reset counter-set list-style-type)
        }
      }
    end

    # config to preserve inline styling that we want to keep at p&span
    def css_inline_config
      {
        css: {
          properties: %w(font-style font-weight text-decoration)
        }
      }
    end

    def default_config
      {
        elements: %w(table td th tr tbody thead span a p h1 h2 h3 h4 h5 h6 ol ul li div img hr abbr b blockquote br cite
                     code dd dfn dl dt em i kbd mark pre q s samp small strike strong sub sup time u var),
        attributes: {
          'a'    => %w(href title data-toggle id),
          'img'  => %w(alt src style),
          'ol'   => %w(type style start list-style-type class),
          'ul'   => %w(type style start list-style-type),
          'li'   => %w(class),
          'p'    => %w(class style),
          'span' => %w(style),
          'td'   => %w(colspan rowspan style),
          'th'   => %w(colspan rowspan),
          'tr'   => %w(style)
        },
        protocols: {
          'a' => { 'href' => ['http', 'https', :relative] }
        },
        css: {
          properties: %w(background-color border-bottom-width border-left-width border-right-width border-top-width
                         height font-style font-weight list-style-type text-align text-decoration vertical-align width)
        },
        transformers: [ # These transformers Will be executed via .call(), as lambdas
          method(:remove_meanless_styles),
          method(:remove_empty_paragraphs),
          # TODO: need to change parsing tags xpath before, it's relying on spans
          # method(:remove_spans_wo_attrs)
          method(:remove_gdocs_suggestions),
          method(:replace_charts_urls),
          method(:keep_bullets_level)
        ]
      }
    end

    private

    def post_processing_images(nodes)
      nodes
        .css(':not(.o-ld-image-student-worksheet) > img:not([src*=googleapis])')
        .wrap('<div class="o-ld-image-wrap--math u-text--centered"></div>')

      nodes
        .css('.o-ld-image-student-worksheet')
        .wrap('<div class="o-ld-image-wrap--math"></div>')

      nodes
        .css('table .o-ld-image-wrap--math')
        .remove_attr('class')
    end

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

    def keep_bullets_level(env)
      node = env[:node]
      return unless node.element? && node.name == 'li' && node['style'].to_s.include?('margin-left')
      indent = /margin-left\s*:\s*(\d+)/.match(node['style']).try(:[], 1).to_i
      add_css_class(node, "u-ld-indent--l#{(indent - 50) / 30 + 2}") if indent >= 50
    end

    def add_css_class(el, *classes)
      existing = (el[:class] || '').split(/\s+/)
      el[:class] = existing.concat(classes).uniq.join(' ')
    end
  end
end
