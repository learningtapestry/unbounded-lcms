module DocTemplate
  module Tags
    class TaskTag < BaseTag
      TAG_NAME = 'task'.freeze

      def parse(node, opts = {})
        @result = node.replace "<h4>Task #{opts[:value]}</h4>"
        self
      end
    end
  end

  Template.register_tag(Tags::TaskTag::TAG_NAME, Tags::TaskTag)
end
