require 'nokogiri'
require 'content/format_parsers/format_parser'

module Content
  module FormatParsers
    class XmlFormatParser < FormatParser
      FORMAT = :xml

      def parse
        xml = Nokogiri::XML(self.resource_data)

        if xml.errors.size == 0
          self.content = xml
        end
      end
    end
  end
end
