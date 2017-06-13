module DocTemplate
  module Tags
    class HeadingTag < BaseTag
      TEMPLATE = 'ela-headings.html.erb'.freeze

      def parse(node, opts = {})
        # we have to collect all the next siblings until next stop-tag
        content = wrap_content(node)

        node = node.replace(
          parse_template({ content: parse_nested(content, opts),
                           heading: "<h3>#{heading(opts[:value])}</h3>",
                           tag: self.class::TAG_NAME },
                         TEMPLATE)
        )
        @result = node
        self
      end

      private

      def prefix
        self.class::TITLE_PREFIX
      end

      def heading(value)
        value.include?(prefix + ':') ? value : "#{prefix}: #{value}"
      end
    end

    class RubricTag < HeadingTag
      TAG_NAME = 'rubric'.freeze
      TITLE_PREFIX = 'Rubric'.freeze
    end

    class JsTag < HeadingTag
      TAG_NAME = 'js'.freeze
      TITLE_PREFIX = 'Juicy Sentences'.freeze
    end

    class EtTag < HeadingTag
      TAG_NAME = 'et'.freeze
      TITLE_PREFIX = 'Exit Ticket'.freeze
    end

    class PhotoTag < HeadingTag
      TAG_NAME = 'photo'.freeze
      TITLE_PREFIX = 'Photograph'.freeze
    end

    class AssessTag < HeadingTag
      TAG_NAME = 'assess'.freeze
      TITLE_PREFIX = 'Assessment'.freeze
    end

    class ShTag < HeadingTag
      TAG_NAME = 'sh'.freeze

      def heading(value)
        value
      end
    end

    class KeyTag < HeadingTag
      TAG_NAME = 'key'.freeze

      def heading(value)
        "#{value}<br/>(For Teacher Reference)"
      end
    end

    class ThTag < HeadingTag
      TAG_NAME = 'th'.freeze

      def heading(value)
        "#{value}<br/>(For Teacher Reference)"
      end
    end
  end

  Template.register_tag(Tags::RubricTag::TAG_NAME, Tags::RubricTag)
  Template.register_tag(Tags::JsTag::TAG_NAME, Tags::JsTag)
  Template.register_tag(Tags::EtTag::TAG_NAME, Tags::EtTag)
  Template.register_tag(Tags::PhotoTag::TAG_NAME, Tags::PhotoTag)
  Template.register_tag(Tags::AssessTag::TAG_NAME, Tags::AssessTag)
  Template.register_tag(Tags::ShTag::TAG_NAME, Tags::ShTag)
  Template.register_tag(Tags::KeyTag::TAG_NAME, Tags::KeyTag)
  Template.register_tag(Tags::ThTag::TAG_NAME, Tags::ThTag)
end
