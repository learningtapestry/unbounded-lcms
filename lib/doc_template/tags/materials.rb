module DocTemplate
  class MaterialsTag < Tag
    include ERB::Util

    # BREAK_TAG_NAME = 'break'.freeze
    TAG_NAME = 'materials'.freeze
    TEMPLATE = 'materials.html.erb'

    def parse(node, opts = {})
      # we have to collect all the nect siblings until next activity-metadata
      @content = [].tap do |result|
                    while (sibling = node.next_sibling) do
                      break if sibling.content =~ /#{ActivityMetadataSectionTag::TAG_NAME}/
                      break if sibling.content =~ /#{ActivityMetadataTypeTag::TAG_NAME}/
                      result << sibling.to_html
                      sibling.remove
                    end
                  end.join

      template = File.read template_path(TEMPLATE)
      node.replace ERB.new(template).result(binding)
      @result = node
      self
    end
  end

  Template.register_tag(MaterialsTag::TAG_NAME, MaterialsTag)
end
