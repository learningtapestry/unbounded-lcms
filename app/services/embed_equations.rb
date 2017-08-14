# frozen_string_literal: true

class EmbedEquations
  class << self
    def call(content)
      frag = Nokogiri::HTML.fragment(content)

      frag.css('img').each do |img|
        equation_node = convert_tex_to_html(img[:src])
        next unless equation_node
        img.replace(equation_node)
      end

      frag.to_s
    end

    private

    def convert_tex_to_html(url)
      uri = URI.parse(url)
      params = Rack::Utils.parse_nested_query(uri.query)
      return unless params['cht'] == 'tx'

      tex = params['chl']
      return if tex.blank?

      html = `tex2html -- '#{tex}'`
      Nokogiri::HTML.fragment(html).at_css('span')
    end
  end
end
