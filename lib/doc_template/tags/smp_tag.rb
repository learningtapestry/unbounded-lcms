module DocTemplate
  module Tags
    class SmpTag < BaseTag
      END_VALUE = 'end'.freeze
      TAG_NAME = 'smp'.freeze
      TEMPLATE = 'smp.html.erb'.freeze

      def parse(node, opts = {})
        if opts[:value] != END_VALUE
          # If this is start tag - replace the tag with custom mark
          node = node.replace %( <div smp-start smp-value="#{opts[:value]}"></div> )
        else
          # End tag - need to find previous start mark and wrap all what's in between
          nodes = nodes_to_wrap node
          nodes.each(&:remove)

          @content = nodes.reverse.map(&:to_html).join

          if @smp.present?
            template = File.read template_path(TEMPLATE)
            node.replace ERB.new(template).result(binding)
          end
        end

        @result = node
        self
      end

      private

      def nodes_to_wrap(node)
        node = node.previous_sibling
        [].tap do |result|
          while (node = node.try(:previous_sibling))
            if node.has_attribute?('smp-start')
              @smp = node.attributes['smp-value'].value.split(';').map(&:strip)
              node.remove
              break
            end

            result << node
          end
        end
      end
    end
  end

  Template.register_tag(Tags::SmpTag::TAG_NAME, Tags::SmpTag)
end
