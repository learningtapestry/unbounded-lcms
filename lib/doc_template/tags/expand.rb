module DocTemplate
  class ExpandTag < Tag
    include ERB::Util

    BREAK_TAG_NAME = 'break'.freeze
    TAG_NAME = 'expand'.freeze
    TEMPLATE = 'expand.html.erb'

    def parse(node, opts = {})
      return unless (table = node.ancestors('table').first)

      @content, @content_hidden = fetch_content table

      # we should replace the whole table with new content
      template = File.read template_path(TEMPLATE)
      table.replace ERB.new(template).result(binding)
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

  Template.register_tag(ExpandTag::TAG_NAME, ExpandTag)
end
