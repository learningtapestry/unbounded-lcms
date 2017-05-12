module DocTemplate
  module Tags
    class ExpandTag < BaseTag
      include ERB::Util

      BREAK_TAG_NAME = 'break'.freeze
      TAG_NAME = 'expand'.freeze
      TEMPLATE = 'expand.html.erb'.freeze

      def parse(node, opts = {})
        return self unless (table = node.ancestors('table').first)

        @subject = (opts[:metadata].try(:[], 'subject').presence || 'ela').downcase
        @content, @content_hidden = fetch_content table

      # we should replace the whole table with new content
      template = File.read template_path(TEMPLATE)
      content = ERB.new(template).result(binding)# Handle internal tags
      table.replace parse_nested(content)
      @result = table
      self
    end

      private

      def fetch_content(node)
        broken = false
        content_visible = []
        content_hidden = []

        # iterates over all child nodes looking for break tag
        node.at_xpath('.//tr[2]/td').children.each do |child|
          (broken = true) && next if child.text.index("[#{BREAK_TAG_NAME}]")
          child.remove_attribute('class')
          child.children.each { |x| x.remove_attribute('class') }
          broken ? content_hidden.push(child) : content_visible.push(child)
        end

        [content_visible.map(&:to_html).join, content_hidden.map(&:to_html).join]
      end
    end
  end

  Template.register_tag(Tags::ExpandTag::TAG_NAME, Tags::ExpandTag)
end
