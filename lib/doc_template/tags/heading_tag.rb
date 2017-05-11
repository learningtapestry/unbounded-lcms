module DocTemplate
  class HeadingTag < Tag
    def parse(node, opts = {})
      node.replace "<h3>#{heading opts[:value]}</h3>"
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

  Template.register_tag(RubricTag::TAG_NAME, RubricTag)
  Template.register_tag(JsTag::TAG_NAME, JsTag)
  Template.register_tag(EtTag::TAG_NAME, EtTag)
  Template.register_tag(PhotoTag::TAG_NAME, PhotoTag)
  Template.register_tag(AssessTag::TAG_NAME, AssessTag)
  Template.register_tag(ShTag::TAG_NAME, ShTag)
  Template.register_tag(KeyTag::TAG_NAME, KeyTag)
  Template.register_tag(ThTag::TAG_NAME, ThTag)
end
