module DocTemplate
  class SectionTag < Tag
    TAG_NAME = 'section'.freeze

    def parse(node, opts = {})
      node.replace "<h3>#{opts[:value]}</h3>"
      @result = node
      self
    end
  end

  Template.register_tag(SectionTag::TAG_NAME, SectionTag)
end
