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
      @result || ''
    end

    def remove_node
      start_tag_index = @result.children.index(@result.at_xpath(STARTTAG_XPATH))
      end_tag_index = @result.children.index(@result.at_xpath(ENDTAG_XPATH))
      @result.children[start_tag_index..end_tag_index].each do |node|
        # a tag followed or preceeded by anything else
        if node.content =~ /.+\[[^\]]+\]|\[[^\]]+\].+/
          node.content = node.content.gsub(/\[?[^\[]+\]|\[[^\]]+\]?/, '')
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

    def ela6?(metadata)
      metadata.resource_subject == 'ela' && metadata.grade == '6'
    end
  end
end
