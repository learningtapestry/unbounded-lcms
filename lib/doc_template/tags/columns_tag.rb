module DocTemplate
  module Tags
    class ColumnsTag < BlockTag
      include ERB::Util

      END_VALUE = 'end'.freeze
      SPLIT_SYMBOL = ';'.freeze
      TAG_NAME = 'columns'.freeze
      TEMPLATE = 'columns.html.erb'.freeze

      def parse(node, opts = {})
        if opts[:value] == END_VALUE
          node.remove
        else
          @images = []
          @tags = []

          nodes = fetch_content node
          nodes.map(&:remove)

          data = nodes
                   .map { |n| n.content.squish }
                   .join
                   .split(SPLIT_SYMBOL)
                   .map(&:strip)
                   .reject(&:blank?)
                   .in_groups_of(opts[:value].to_i, '')

          @rows = substitute_images(data).map do |row|
                    row.map do |td|
                      substitute_tags_in td, @tags
                    end
                  end

          if @rows.any?
            template = File.read template_path(TEMPLATE)
            node = node.replace ERB.new(template).result(binding)
          end
        end

        @result = node
        self
      end

      private

      #
      # Going down the DOM tree until the end tag. Placing own markers
      # for nested tags and images to revert them back later on
      #
      def fetch_content(node)
        re = /\[#{TAG_NAME}:\s*#{END_VALUE}\]/
        [].tap do |result|
          while (node = node.next_sibling)
            node.remove && break if node.content.downcase.index(re).present?

            fetch_images node
            add_tags_from node, @tags

            result << node
          end
        end
      end

      def fetch_images(node)
        node.xpath('.//img').each do |img|
          @images << {
            src: img['src'],
            style: img['style']
          }
          img.replace "{image: #{@images.size - 1}}"
        end
      end

      def substitute_images(data)
        re = /{image: (\d)+}/
        data.map do |row|
          row.map do |td|
            if (m = re.match td) && (img = @images[m[1].to_i]).present?
              td = td.sub re, %(<img src="#{img[:src]}" style="#{img[:style]}" />)
            end
            td
          end
        end
      end
    end
  end

  Template.register_tag(Tags::ColumnsTag::TAG_NAME, Tags::ColumnsTag)
end
