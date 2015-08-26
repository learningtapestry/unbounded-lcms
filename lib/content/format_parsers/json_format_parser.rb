require 'json'
require 'content/format_parsers/format_parser'

module Content
  module FormatParsers
    class JsonFormatParser < FormatParser
      FORMAT = :json

      def parse
        begin
          if self.resource_data.kind_of?(Hash)
            self.content = self.resource_data
            self.resource_data = JSON.dump(self.resource_data)
          else
            self.content = JSON.parse(self.resource_data)
          end
        rescue; end
      end
    end
  end
end
