module DocTemplate
  class ActivityMetadataSectionTag < Tag
    TAG_NAME = 'activity-metadata-section'.freeze

    def parse(node, opts = {})
      section = opts[:activity].section_by_tag(opts[:value])
      node.replace(
        <<-HEADER
          <h2 id="#{section.id}" class='o-ld-title c-ld-toc u-margin-top--large' data-node-time="#{section.time}">
            <span class='o-ld-title__title o-ld-title__title--h2'>#{section.title}</span>
            <span class='o-ld-title__time o-ld-title__time--h2'>#{section.time} mins</span>
          </h2>
        HEADER
      )
      @result = node
      self
    end
  end

  Template.register_tag(ActivityMetadataSectionTag::TAG_NAME, ActivityMetadataSectionTag)
end
