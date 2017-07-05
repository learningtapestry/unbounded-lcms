module DocTemplate
  module Tags
    class PageBreakTag < BaseTag
      TAG_NAME = /page(-|\s*)break/

      def parse(node, *_)
        @content = %(<div class="u-pdf-alwaysbreak"></div>)
        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::PageBreakTag::TAG_NAME, Tags::PageBreakTag)
end
