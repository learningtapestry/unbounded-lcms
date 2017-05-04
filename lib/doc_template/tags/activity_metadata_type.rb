module DocTemplate
  class ActivityMetadataTypeTag < Tag
    TAG_NAME = 'activity-metadata-type'.freeze

    def parse(node, opts = {})
      node.replace "<h3 class='toc'>#{opts[:value]}</h3>"
      @result = node
      self
    end
  end

  Template.register_tag(ActivityMetadataTypeTag::TAG_NAME, ActivityMetadataTypeTag)
end
