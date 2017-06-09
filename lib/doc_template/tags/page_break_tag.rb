module DocTemplate
  module Tags
    class PageBreakTag < BaseTag
      TAG_NAME = /page(-|\s*)break/

      def parse(node, _opts = {})
        @result = node.replace("<div class='u-pdf-alwaysbreak'></div>")
        self
      end
    end
  end

  Template.register_tag(Tags::PageBreakTag::TAG_NAME, Tags::PageBreakTag)
end
