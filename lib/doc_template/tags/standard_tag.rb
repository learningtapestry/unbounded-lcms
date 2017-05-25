module DocTemplate
  module Tags
    class StandardTag < BaseTag
      include ERB::Util

      STANDARD_RE = /[^\[\]]*\[(ela\.)?((rl|ri|rf|w|sl|l)\.[^\]]+)\]/i # [rl.2.2a.2]
      TAG_NAME = /(ela\.)?((rl|ri|rf|w|sl|l)\.[^\]]+)/ # RL.2.4 or ELA.RL.2.4
      TAG_RE = /\[[^\]]*\]/
      TAG_SEPARATOR = '[separator]'.freeze
      TEMPLATE = 'standard.html.erb'.freeze

      def parse(node, _)
        content = render_template node
        loop do
          break unless STANDARD_RE =~ content
          content = render_template Nokogiri::HTML.fragment(content)
        end

        # preserve `li` element
        if node.name == 'li'
          node.replace "<li>#{content}</li>"
        else
          node.replace content
        end

        @result = node
        self
      end

      private

      # Extracting content outside the tag
      # TODO: Extract to the parent class
      def fetch_data(source)
        @preserved_style = %r{<span (style=[^.>]*)>[^<]+</span>$}.match(source).try(:[], 1)
        {}.tap do |result|
          data = source.squish
                   .sub(TAG_RE, TAG_SEPARATOR)
                   .split(TAG_SEPARATOR, 2)
                   .reject(&:blank?)
          break unless data
          result[:prepend] = data[0]
          result[:append] = data[1]
        end
      end

      def fetch_description(text)
        return unless (matches = STANDARD_RE.match text)

        name = matches[2].downcase.to_sym
        Standard.search_by_name(name).first.try(:description)
      end

      def render_template(node)
        @data = fetch_data node.inner_html
        @standard_shortcut = TAG_RE.match(node.content).try(:[], 0).try(:gsub, /[\[\]]/, '')
        @description = fetch_description node.content

        template = File.read template_path(TEMPLATE)
        ERB.new(template).result(binding).gsub(/\s{2,}</, '<')
      end
    end
  end

  Template.register_tag(Tags::StandardTag::TAG_NAME, Tags::StandardTag)
end
