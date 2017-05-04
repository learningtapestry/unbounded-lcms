module DocTemplate
  class ActivityMetadataSectionTag < Tag
    TAG_NAME = 'activity-metadata-section'.freeze

    def parse(node, opts = {})
      node.replace "<h2 class='toc'>#{opts[:value]}</h2>"
      @result = node
      self
    end
  end

  Template.register_tag(ActivityMetadataSectionTag::TAG_NAME, ActivityMetadataSectionTag)
end
