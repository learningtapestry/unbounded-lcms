module DocTemplate
  class Tag
    def self.parse(node)
      tag = new
      tag.parse(node)
    end

    def parse(node)
      raise NotImplementedError
    end

    def render
      raise NotImplementedError
    end

    def selfremove
      start_tag_index = @result.children.index(@result.at_xpath(STARTTAG_XPATH))
      end_tag_index = @result.children.index(@result.at_xpath(ENDTAG_XPATH))
      @result.children[start_tag_index..end_tag_index].each do |node|
        # closed and opened tag in the same node case
        if node.content =~ /\].*?\[/
          node.content = node.content.tr(']', '')
        else
          node.remove
        end
      end
    end
  end
end
