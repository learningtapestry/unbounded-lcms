module DocTemplate
  class SourceTag < Tag
    TAG_NAME = 'source'.freeze

    def parse(node, opts = {})
      node.remove
      @result = ''
      self
    end
  end

  Template.register_tag(SourceTag::TAG_NAME, SourceTag)
end
