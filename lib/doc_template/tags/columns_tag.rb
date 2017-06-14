module DocTemplate
  module Tags
    class ColumnsTag < BaseTag
      include ERB::Util

      ALIGNMENT_RE = /^align-right\s/i
      END_VALUE = 'end'.freeze
      SPLIT_SYMBOL = ';'.freeze
      TAG_NAME = 'columns'.freeze
      TEMPLATE = 'columns.html.erb'.freeze

      def parse(node, opts = {})
        @opts = opts
        if @opts[:value] == END_VALUE
          node.remove
        else
          @images = []
          @tags = []

          data = fetch_content node

          rows = substitute_images(data).map do |row|
            row.map do |td|
              substitute_tags_in td, @tags
              handle_alignment_for td
            end
          end

          node = node.replace parse_template({ rows: rows }, TEMPLATE) if rows.any?
        end

        @result = node
        self
      end

      private

      def add_tags_from(node, tags = [])
        re = DocTemplate::Tags::StandardTag::TAG_RE
        return unless (m = re.match node.inner_html)

        m.to_a.each do |tag|
          tags << tag
          node.content = node.content.sub re, "{tag: #{tags.size - 1}}"
        end

        tags
      end

      #
      # Going down the DOM tree until the end tag. Placing own markers
      # for nested tags and images to revert them back later on
      #
      def fetch_content(node)
        re = /\[#{TAG_NAME}:\s*#{END_VALUE}\]/
        nodes = [].tap do |result|
          while (node = node.next_sibling)
            node.remove && break if node.content.downcase.index(re).present?

            fetch_images node
            add_tags_from node, @tags

            result << node
          end
        end

        nodes.map(&:remove)

        # Handles alignment.
        # Content team places ` r;` to make right alignment for the next column
        # Just swap position of the ` r` and `;` to simplify the alogorithm
        data = nodes
                 .map { |n| n.content.squish }
                 .join
                 .gsub(' r;', ';align-right ')

        data
          .split(SPLIT_SYMBOL)
          .map(&:strip)
          .reject(&:blank?)
          .in_groups_of(@opts[:value].to_i, '')
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

      def handle_alignment_for(td)
        {}.tap do |result|
          result[:content] = td.sub ALIGNMENT_RE, ''
          result[:css_class] = 'text-right' if td =~ ALIGNMENT_RE
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

      def substitute_tags_in(content, tags = [])
        re = /{tag: (\d)+}/
        content.scan(re).each do |idx|
          next unless (tag = tags[idx.first.to_i]).present?
          parsed_tag = parse_nested "<p><span>#{tag}</span></p>"
          content = content.sub re, parsed_tag
        end
        content
      end
    end
  end

  Template.register_tag(Tags::ColumnsTag::TAG_NAME, Tags::ColumnsTag)
end
