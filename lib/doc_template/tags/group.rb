module DocTemplate
  class GroupTag < Tag
    TAG_NAME = 'group'.freeze

    def parse(node, opts = {})
      group = opts[:agenda].group_by_id(opts[:value].parameterize)
      node.replace(
        <<-HEADER
          <h2 id="#{group.id}" class='o-ld-title c-ld-toc u-margin-top--large' data-node-time="#{group.metadata.time}">
            <span class='o-ld-title__title o-ld-title__title--h2'>#{group.title}</span>
            <span class='o-ld-title__time o-ld-title__time--h2'>#{group.metadata.time} mins</span>
          </h2>
        HEADER
      )
      @result = node
      self
    end
  end

  Template.register_tag(GroupTag::TAG_NAME, GroupTag)
end
