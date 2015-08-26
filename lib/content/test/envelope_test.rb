require 'content/test/test_helper'
require 'content/envelope'

module Content
  module Test
    class EnvelopeTest < ContentTestBase

      include EnvelopeHelpers

      def test_find_resource_data_description
        envelope = read_envelope('json_description')
        description = Envelope.find_resource_data_description(envelope)
        assert description.has_key?('doc_type')
      end

      def test_find_resource_data_description_no_description
        envelope = read_envelope('json_no_description')
        description = Envelope.find_resource_data_description(envelope)
        assert description.has_key?('doc_type')
      end

      def test_find_or_create_lr_document
        envelope = read_envelope('json')
        lr_document = Envelope.find_or_create_lr_document(envelope)
        
        assert_equal '2c55523bdf25416b991c1f0ac0c44be9', lr_document.doc_id
        assert_equal true, lr_document.active
        assert_equal 'resource_data', lr_document.doc_type
        assert_equal '0.23.0', lr_document.doc_version
        assert_equal 'Jim Klo @ SRI', lr_document.identity['submitter']
        assert_includes lr_document.keys, 'education'
        assert_equal 'inline', lr_document.payload_placement
        assert_includes lr_document.payload_schema, 'lrmi'
        assert_equal 'metadata', lr_document.resource_data_type
        assert_equal 'http://www.khanacademy.org/video/statistics--sample-variance', lr_document.resource_locator
        assert_kind_of String, lr_document.raw_data
        refute_nil lr_document.resource_data_json
      end

      def test_parse_format_json
        envelope = read_envelope('json')
        resource_data = Envelope.find_resource_data(envelope)
        parsed_doc = Envelope.parse_format(envelope, resource_data)
        assert_kind_of Hash, parsed_doc.content
      end

      def test_parse_format_xml
        envelope = read_envelope('xml')
        resource_data = Envelope.find_resource_data(envelope)
        parsed_doc = Envelope.parse_format(envelope, resource_data)
        assert_kind_of Nokogiri::XML::Document, parsed_doc.content
      end

      def test_guess_format_json
        lr_doc = '{"key": "value"}'
        assert_equal :json, Envelope.guess_format(lr_doc)
      end

      def test_guess_format_xml
        lr_doc = '<doc></doc>'
        assert_equal :xml, Envelope.guess_format(lr_doc)
      end

      def test_guess_format_other
        lr_doc = 'A doc.'
        assert_equal :text, Envelope.guess_format(lr_doc)
      end

    end
  end
end
