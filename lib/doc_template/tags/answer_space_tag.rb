module DocTemplate
  module Tags
    class AnswerSpaceTag < BaseTag
      SPACE_SIZE = {
        s: 5, # small = 5 lines
        m: 10, # medium = 10 lines
        l: 20, # large = 20 lines
      }.freeze
      TAG_NAME = 'answer-space'.freeze

      def parse(node, opts = {})
        num_of_lines = SPACE_SIZE[opts[:value].try(:to_sym)]
        if num_of_lines
          space = '<br>' * num_of_lines
          content = node.to_html.sub(/\[#{self.class::TAG_NAME}:\s?[s|m|l]\]/i, space)
          node = node.replace(content)
        end
        @result = node
        self
      end
    end
  end

  Template.register_tag(Tags::AnswerSpaceTag::TAG_NAME, Tags::AnswerSpaceTag)
end
