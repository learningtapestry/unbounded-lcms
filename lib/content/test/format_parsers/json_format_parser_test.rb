require 'json'

require 'test_helper'
require 'content/format_parsers/json_format_parser'

module Content
  module Test
    class JsonFormatParserTest < ContentTestBase

      include EnvelopeHelpers

      def test_parse
        envelope = read_envelope('json')
        lr_document = JSON.dump(envelope['resource_data_description']['resource_data'])
        parsed = FormatParsers::JsonFormatParser.parse(envelope, lr_document)
        assert_equal lr_document, JSON.dump(parsed.content)
      end

      def test_parse_fail
        envelope = read_envelope('xml')
        lr_document = envelope['resource_data_description']['resource_data']
        refute FormatParsers::JsonFormatParser.parse(envelope, lr_document).valid?
      end

      def test_parsed_doc_format
        envelope = read_envelope('json')
        lr_document = JSON.dump(envelope['resource_data_description']['resource_data'])
        parsed = FormatParsers::JsonFormatParser.parse(envelope, lr_document)
        assert_equal parsed.format, :json
      end

    end
  end
end
