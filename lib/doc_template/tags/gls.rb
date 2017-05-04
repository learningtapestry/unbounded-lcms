module DocTemplate
  class GlsTag < Tag
    TAG_NAME = 'gls'.freeze

    def parse(node, opts = {})
      node.replace "<em>#{opts[:value]}</em>"
      @result = node
      self
    end
  end

  Template.register_tag(GlsTag::TAG_NAME, GlsTag)
end
