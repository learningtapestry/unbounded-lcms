module DocTemplate
  module Tags
    class PositionTag < BaseTag
      include ERB::Util

      TAG_NAME = 'position'.freeze
      TEMPLATE = 'position.html.erb'.freeze

      def parse(node, opts = {})
        return super unless opts[:parent_tags].try(:include?, Tags::MaterialsTag::TAG_NAME)
        return self unless (table = node.ancestors('table').first)

        # added this class to avoid image wrapping
        table.xpath('.//*').add_class('u-ld-not-image-wrap')
        @content = table.at_xpath('.//tr[2]/td').inner_html
        @position = opts[:value].strip

        template = File.read template_path(TEMPLATE)
        new_content = ERB.new(template).result(binding)
        table.replace parse_nested new_content
        @result = table
        self
      end
    end
  end

  # TODO: Currently will work only inside materials tag
  Template.register_tag(Tags::PositionTag::TAG_NAME, Tags::PositionTag)
end
