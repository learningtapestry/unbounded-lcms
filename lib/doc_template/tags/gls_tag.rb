module DocTemplate
  class GlsTag < Tag
    TAG_NAME = 'gls'.freeze

    def parse(node, opts = {})
      @result = node
      @result.at_xpath(STARTTAG_XPATH).before("<em>#{opts[:value]}</em>")
      remove_node
      self
    end
  end

  Template.register_tag(GlsTag::TAG_NAME, GlsTag)
end
