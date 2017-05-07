require_relative './tags/activity_metadata_section'
require_relative './tags/activity_metadata_type'

module DocTemplate
  class ActivityTable
    HEADER_LABEL = 'activity-metadata'.freeze

    def self.parse(fragment)
      new.parse(fragment)
    end

    def parse(fragment)
      placed_sections = []

      [].tap do |result|
        fragment.xpath(".//table/*/tr[1]/td//*[text() = '#{HEADER_LABEL}']").each do |el|
          table = el.ancestors('table').first
          data = fetch table

          # Places activity type tags
          title = "#{data['section-title']} #{data['activity-title']}".parameterize
          table.add_next_sibling "<p><span>[#{ActivityMetadataTypeTag::TAG_NAME}: #{title}]</span></p>"

          # Places new tags to markup future content injection
          # Inserts only once
          if placed_sections.include?(data['section-title'])
            table.remove
          else
            placed_sections << data['section-title']
            table.replace "<p><span>[#{ActivityMetadataSectionTag::TAG_NAME}: #{data['section-title'].parameterize}]</span></p>"
          end

          result << data
        end
      end
    end

    private

    def fetch(table)
      {}.tap do |result|
        table.xpath('.//*/tr[position() > 1]').each do |row|
          result[row.at_xpath('td[1]').text.squish] = row.at_xpath('td[2]').text.squish
        end
      end
    end
  end
end
