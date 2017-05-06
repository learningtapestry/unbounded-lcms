module DocTemplate
  class Tag
    def self.parse(node, opts = {})
      new.parse(node, opts)
    end

    def parse(node, opts = {})
      @result = node
      remove_node
      self
    end

    def parse_nested(node, opts = {})
      Document.parse(Nokogiri::HTML(node), opts.merge(level: 1)).render
    end

    def render
      @result or ''
    end

    def remove_node
      start_tag_index = @result.children.index(@result.at_xpath(STARTTAG_XPATH))
      end_tag_index = @result.children.index(@result.at_xpath(ENDTAG_XPATH))
      @result.children[start_tag_index..end_tag_index].each do |node|
        # closed and opened tag in the same node case or there is other stuff after closing
        if node.content =~ /].*\[/ || node.content =~ /]\s*[[:graph:]]+/
          node.content = node.content.gsub(/\[?.*\]/, '')
        else
          node.remove
        end
      end
    end

    def parse_template(context, template_name)
      @tmpl = context
      template = File.read template_path(template_name)
      ERB.new(template).result(binding)
    end

    def template_path(name)
      File.join Rails.root, 'lib', 'doc_template', 'templates', name
    end
  end
end
