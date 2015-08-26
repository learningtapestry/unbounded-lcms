require 'json'
require 'nokogiri'

require 'content/test/test_helper'
require 'content/format_parsers/nsdl_dc_format_parser'

module Content
  module Test
    class NsdlDcFormatParserTest < ContentTestBase

      include EnvelopeHelpers

      def test_parse
        envelope = read_envelope('nsdl_dc')
        lr_document = envelope['resource_data']
        parsed = FormatParsers::NsdlDcFormatParser.parse(envelope, lr_document)
        assert_kind_of Nokogiri::XML::Document, parsed.content
      end

      def test_parse_bad_escape
        envelope = read_envelope('nsdl_dc_bad_escape')
        lr_document = envelope['resource_data']
        parsed = FormatParsers::NsdlDcFormatParser.parse(envelope, lr_document)
        assert_kind_of Nokogiri::XML::Document, parsed.content
      end

      def test_parse_self_closing_tag
        envelope = read_envelope('nsdl_dc_self_closing_tag')
        lr_document = envelope['resource_data']
        parsed = FormatParsers::NsdlDcFormatParser.parse(envelope, lr_document)
        assert_kind_of Nokogiri::XML::Document, parsed.content
      end

      def test_parse_unescaped
        envelope = read_envelope('nsdl_dc_unescaped')
        lr_document = envelope['resource_data']
        parsed = FormatParsers::NsdlDcFormatParser.parse(envelope, lr_document)
        assert_kind_of Nokogiri::XML::Document, parsed.content
      end

      def test_parse_weird_char
        envelope = read_envelope('nsdl_dc_weird_char')
        lr_document = envelope['resource_data']
        parsed = FormatParsers::NsdlDcFormatParser.parse(envelope, lr_document)
        assert_kind_of Nokogiri::XML::Document, parsed.content
      end

      def test_parse_fail
        envelope = read_envelope('json')
        lr_document = JSON.dump(envelope['resource_data_description']['resource_data'])
        refute FormatParsers::NsdlDcFormatParser.parse(envelope, lr_document).valid?
      end

      def test_parsed_doc_content
        envelope = read_envelope('nsdl_dc')
        lr_document = envelope['resource_data']
        parsed = FormatParsers::NsdlDcFormatParser.parse(envelope, lr_document)
        assert_kind_of Nokogiri::XML::Document, parsed.content
      end

      def test_parsed_doc_format
        envelope = read_envelope('nsdl_dc')
        lr_document = envelope['resource_data']
        parsed = FormatParsers::NsdlDcFormatParser.parse(envelope, lr_document)
        assert_equal parsed.format, :xml
      end
    end
  end
end
