# frozen_string_literal: true

module DocTemplate
  module Tables
    class Base
      def self.parse(fragment)
        new.parse(fragment)
      end

      def data
        @data || {}
      end

      def parse(fragment)
        # get the table
        table = fragment.at_xpath("table//*[contains(., '#{self.class::HEADER_LABEL}')]")
        return self unless table

        table.search('br').each { |br| br.replace("\n") }
        @data = fetch table

        table.remove
        self
      end

      def fetch_materials(data, key)
        return data if (materials = data[key.to_s]).blank?
        data['material_ids'] =
          materials.split(',').compact.map do |identifier|
            Material.find_by(identifier: identifier.strip)&.id
          end.compact
        data
      end

      private

      def fetch(table)
        {}.tap do |result|
          table.xpath('.//tr[position() > 1]').each do |row|
            key = row.at_xpath('./td[1]').text.strip.downcase
            next if key.blank?
            value = if self.class::HTML_VALUE_FIELDS.include? key
                      row.at_xpath('./td[2]').inner_html
                    else
                      row.at_xpath('./td[2]').text
                    end.squish

            result[key] = value
          end
        end
      end
    end
  end
end
