module DocTemplate
  class ActivityMetadataSectionTag < Tag
    TAG_NAME = 'activity-metadata-section'.freeze

    def parse(node, opts = {})
      section = opts[:activity].section_by_tag(opts[:value])
      node.replace(
        <<-HEADER
          <h2 class='o-ld-title c-ld-toc' data-node-time="#{section.time}">
            <span class='o-ld-title__title'>#{section.section_title}</span>
            <span class='o-ld-title__time'>#{section.time} mins</span>
          </h2>
        HEADER
      )
      @result = node
      self
    end
  end

  Template.register_tag(ActivityMetadataSectionTag::TAG_NAME, ActivityMetadataSectionTag)
end
