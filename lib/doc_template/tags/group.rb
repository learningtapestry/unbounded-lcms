module DocTemplate
  class GroupTag < Tag
    TAG_NAME = 'group'.freeze

    def parse(node, opts = {})
      group = opts[:agenda].group_by_id(opts[:value].parameterize)
      return parse_ela6(node, group) if ela6?(opts[:metadata])
      node.replace(tag_html(group))
      @result = node
      self
    end

    private

    def tag_html(group)
      <<-HEADER
        <h2 id="#{group.id}" class='o-ld-title c-ld-toc u-margin-top--large' data-node-time="#{group.metadata.time}">
          <span class='o-ld-title__title o-ld-title__title--h2'>#{group.title}</span>
          <span class='o-ld-title__time o-ld-title__time--h2'>#{group.metadata.time} mins</span>
        </h2>
      HEADER
    end

    def parse_ela6(node, group)
      @result = node.ancestors('table').before(tag_html(group))
      node.remove
      self
    end
  end

  Template.register_tag(GroupTag::TAG_NAME, GroupTag)
end
