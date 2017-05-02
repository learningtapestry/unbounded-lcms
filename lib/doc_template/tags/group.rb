module DocTemplate
  class GroupTag < Tag
    TAG_NAME = 'group'.freeze

    def parse(node, opts = {})
      node.replace "<h2>#{opts[:value]}</h2>"
      @result = node
      self
    end
  end

  Template.register_tag(GroupTag::TAG_NAME, GroupTag)
end
