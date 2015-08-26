require 'content/format_parsers/xml_format_parser'

module Content
  module FormatParsers
    class NsdlDcFormatParser < XmlFormatParser
      def parse
        # Remove redundant escapes.
        self.resource_data = self.resource_data.gsub("\\\"", '"')

        # Remove self-closing tags.
        self.resource_data = self.resource_data.gsub(/\<dc:\w+?\/\>/, '')

        # Remove unicode control characters.
        # Ref. http://stackoverflow.com/questions/28673260/remove-weird-invalid-character-in-ruby
        self.resource_data = self.resource_data.gsub(/[^(\u0009|\u000A|\u000D|\u0020-\uD7FF|\uE000-\uFFFD|\u10000-\u10FFFF)]/, "\uFFFD")

        # Escape <dc:> namespace.
        self.resource_data = self.resource_data.gsub(/\<dc:.*?\>(.*?)\<\/dc:.*?\>/m) do |match_str|
          match = Regexp.last_match
          full = match[0]
          to_replace = match[1]
          before = full[0..(full.index(to_replace)-1)]
          after = full[(before.size+to_replace.size)..-1]
          replaced = to_replace.encode(xml: :text)
          before + replaced + after
        end

        super
      end
    end
  end
end
