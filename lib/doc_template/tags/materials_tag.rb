module DocTemplate
  module Tags
    class MaterialsTag < BaseTag
      TAG_NAME = 'materials'.freeze
      TEMPLATE = 'materials.html.erb'.freeze

      def parse(node, opts = {})
        # we have to collect all the next siblings until next activity-metadata
        content = Nokogiri::HTML.fragment content_until_break(node)
        # added this class to avoid image wrapping
        content.xpath('.//img/..').add_class('u-ld-not-image-wrap')

        content = parse_nested content.to_s, opts.merge(parent_tags: [self.class::TAG_NAME])
        @content = parse_template content, TEMPLATE

        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::MaterialsTag::TAG_NAME, Tags::MaterialsTag)
end
