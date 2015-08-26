require 'content/format_parsers/format_parser'

module Content
  module FormatParsers
    class TextFormatParser < FormatParser 
      FORMAT = :text
             
      def parse
        self.content = self.lr_document
      end
    end
  end
end
