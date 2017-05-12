module DocTemplate
  module Tags
    class VocabularyTag < BaseTag
      include ERB::Util

      TAG_NAME = 'vocabulary'.freeze
      TEMPLATE = 'vocabulary.html.erb'.freeze

      def parse(node, opts = {})
        return self unless (table = node.ancestors('table').first)

        @sections = fetch_content table

        # we should replace the whole table with new content
        template = File.read template_path(TEMPLATE)
        table.replace ERB.new(template).result(binding)
        @result = table
        self
      end

      private

      def fetch_content(node)
        [].tap do |result|
          # omit the first row
          cur_section = nil
          node.xpath('.//tr[position() > 1]').each do |tr|
            if (td_header = tr.at_xpath "./td[@colspan = '2']")
              result << cur_section if cur_section.present?
              cur_section = { title: td_header.text }
            elsif cur_section.present?
              cur_section[:words] ||= []
              cur_section[:words] << { name: tr.at_xpath('./td[1]').text, definition: tr.at_xpath('./td[2]').text }
            end
          end
          result << cur_section
        end
      end
    end
  end

  Template.register_tag(Tags::VocabularyTag::TAG_NAME, Tags::VocabularyTag)
end
