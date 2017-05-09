module DocTemplate
  class ActivityMetadataSectionTag < Tag
    TAG_NAME = 'activity-metadata-section'.freeze
    TEMPLATE = 'h2-header.html.erb'.freeze

    def parse(node, opts = {})
      section = opts[:activity].section_by_tag(opts[:value])
      node.replace(parse_template(section, TEMPLATE))
      @result = node
      self
    end
  end

  Template.register_tag(ActivityMetadataSectionTag::TAG_NAME, ActivityMetadataSectionTag)
end
