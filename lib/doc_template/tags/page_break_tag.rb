# frozen_string_literal: true

module DocTemplate
  module Tags
    class PageBreakTag < BaseTag
      TAG_NAME = /page(-|\s*)break/

      def parse(node, opts)
        @content = if gdoc?(opts)
                     '<p>--GDOC-PAGE-BREAK--</p>'
                   else
                     '<div class="u-pdf-alwaysbreak do-not-strip"></div>'
                   end
        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::PageBreakTag::TAG_NAME, Tags::PageBreakTag)
end
