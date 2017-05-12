module DocTemplate
  module Tags
    class IndentTag < BaseTag
      TAG_NAME = 'indent'.freeze

      def parse(node, opts = {})
        @result = node
        classes = node['class'].to_s.split(/\s+/)
        node['class'] = classes.push('indented').uniq.join ' '
        remove_node
        self
      end
    end
  end

  Template.register_tag(Tags::IndentTag::TAG_NAME, Tags::IndentTag)
end
