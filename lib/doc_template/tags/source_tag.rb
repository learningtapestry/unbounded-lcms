module DocTemplate
  module Tags
    class SourceTag < BaseTag
      TAG_NAME = 'source'.freeze

      def parse(node, opts = {})
        node.remove
        @result = ''
        self
      end
    end
  end

  Template.register_tag(Tags::SourceTag::TAG_NAME, Tags::SourceTag)
end
