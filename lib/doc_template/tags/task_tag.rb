module DocTemplate
  module Tags
    class TaskTag < BaseTag
      TAG_NAME = 'task'.freeze

      def parse(node, opts = {})
        @content = "<h4>Task #{opts[:value]}</h4>"
        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::TaskTag::TAG_NAME, Tags::TaskTag)
end
