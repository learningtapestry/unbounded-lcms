require 'json'
require 'nokogiri'

require 'test_helper'
require 'content/format_parsers/xml_format_parser'

module Content
  module Test
    class XmlFormatParserTest < ContentTestBase

      include EnvelopeHelpers

      def test_parse
        envelope = read_envelope('xml')
        lr_document = envelope['resource_data_description']['resource_data']
        parsed = FormatParsers::XmlFormatParser.parse(envelope, lr_document)
        assert_kind_of Nokogiri::XML::Document, parsed.content
      end

      def test_parse_fail
        envelope = read_envelope('json')
        lr_document = JSON.dump(envelope['resource_data_description']['resource_data'])
        refute FormatParsers::XmlFormatParser.parse(envelope, lr_document).valid?
      end

      def test_parsed_doc_content
        envelope = read_envelope('xml')
        lr_document = envelope['resource_data_description']['resource_data']
        parsed = FormatParsers::XmlFormatParser.parse(envelope, lr_document)
        assert_kind_of Nokogiri::XML::Document, parsed.content
      end

      def test_parsed_doc_format
        envelope = read_envelope('xml')
        lr_document = envelope['resource_data_description']['resource_data']
        parsed = FormatParsers::XmlFormatParser.parse(envelope, lr_document)
        assert_equal parsed.format, :xml
      end
      
    end
  end
end
