module DocTemplate
  class SectionTag < Tag
    TAG_NAME = 'section'.freeze

    def parse(node, opts = {})
      section = opts[:agenda].section_by_id(opts[:value].parameterize)
      node.replace(
        <<-HEADER
          <h3 id="#{section.id}" class='o-ld-title c-ld-toc u-margin-top--large' data-node-time="#{section.metadata.time}">
            <span class='o-ld-title__title o-ld-title__title--h3'>#{section.title}</span>
            <span class='o-ld-title__time o-ld-title__time--h3'>#{section.metadata.time} mins</span>
          </h3>
        HEADER
      )
      @result = node
      self
    end
  end

  Template.register_tag(SectionTag::TAG_NAME, SectionTag)
end
