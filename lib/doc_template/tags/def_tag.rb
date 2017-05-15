module DocTemplate
  module Tags
    class DefTag < BaseTag
      include ERB::Util

      TAG_NAME = 'def'.freeze
      TAG_SEPARATOR = '[separator]'.freeze
      TEMPLATE = 'def.html.erb'.freeze

      def parse(node, opts = {})
        # preserving text around tag
        # TODO: Extract to the parent class

        # Need to extract the Tag and preserves all the styling inside it
        node_html = node.inner_html
        start_pos = node_html.index '['
        end_pos = node_html.rindex ']'
        needle = node_html[start_pos..end_pos]
        @preserved_style = /<span (style=[^.>]*)>[^<]*$/.match(needle).try(:[], 1)

        @data = {}
        if (data = node_html.sub(needle, TAG_SEPARATOR).split(TAG_SEPARATOR, 2).map(&:squish))
          @data[:prepend] = data[0]
          @data[:append] = data[1]
        end

        @subject = (opts[:metadata].try(:[], 'subject').presence || 'ela').downcase
        @definition, @description = opts[:value].split(';').map(&:strip)

        template = File.read template_path(TEMPLATE)
        node.replace ERB.new(template).result(binding)
        @result = node
        self
      end
    end
  end

  Template.register_tag(Tags::DefTag::TAG_NAME, Tags::DefTag)
end
