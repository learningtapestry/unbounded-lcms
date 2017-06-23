module DocTemplate
  module Tags
    class MaterialsTag < BaseTag
      TAG_NAME = 'materials'.freeze
      TEMPLATE = 'materials.html.erb'.freeze

      def parse(node, opts = {})
        # we have to collect all the next siblings until next activity-metadata
        content = content_until_break(node)
        # added this class to avoid image wrapping
        content = Nokogiri::HTML.fragment(content)
        content.xpath('.//img/..').add_class('u-ld-not-image-wrap')

        # TODO: maybe we need to expand parent tags approach to all nested tags
        node = node.replace(
          parse_template(
            parse_nested(content.to_s, opts.merge(parent_tags: [self.class::TAG_NAME])),
            TEMPLATE
          )
        )
        @result = node
        self
      end
    end
  end

  Template.register_tag(Tags::MaterialsTag::TAG_NAME, Tags::MaterialsTag)
end
