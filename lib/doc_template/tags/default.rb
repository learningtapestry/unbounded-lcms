module DocTemplate
  class DefaultTag < Tag
    def parse(node)
      @result = node
      selfremove
      self
    end

    def render
      @result
    end
  end

  Template.register_tag('default'.freeze, DefaultTag)
end
