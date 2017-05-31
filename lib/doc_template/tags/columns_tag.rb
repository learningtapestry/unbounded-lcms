module DocTemplate
  module Tags
    class ColumnsTag < BaseTag
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

          # p @images

          data = nodes
                   .map { |n| n.content.squish }
                   .join
                   .split(SPLIT_SYMBOL)
                   .map(&:strip)
                   .reject(&:blank?)
                   .in_groups_of(opts[:value].to_i, '')

          data = substitute_images data
          @rows = substitute_tags data

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
        [].tap do |result|
          while (node = node.next_sibling)
            node.remove && break if node.content.downcase.index("[#{TAG_NAME}: #{END_VALUE}]").present?

            fetch_images(node)
            fetch_tags(node)

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

      def fetch_tags(node)
        re = DocTemplate::Tags::StandardTag::TAG_RE
        return [] unless (m = re.match node.inner_html)

        m.to_a.each do |tag|
          @tags << tag
          node.content = node.content.sub re, "{tag: #{@tags.size - 1}}"
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

      def substitute_tags(data)
        re = /{tag: (\d)+}/
        data.map do |row|
          row.map do |td|
            if (m = re.match td) && (tag = @tags[m[1].to_i]).present?
              # render tag
              content = parse_nested "<p><span>#{tag}</span></p>"
              td = td.sub re, content
            end
            td
          end
        end
      end
    end
  end

  Template.register_tag(Tags::ColumnsTag::TAG_NAME, Tags::ColumnsTag)
end
