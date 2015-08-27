require 'json'
require 'content/models'
require 'content/format_parsers/json_format_parser'
require 'content/format_parsers/xml_format_parser'
require 'content/format_parsers/nsdl_dc_format_parser'
require 'content/format_parsers/text_format_parser'

module Content
  module Envelope

    def self.find_resource_data(envelope)
      envelope['resource_data'] || 
      (envelope['resource_data_description'] && envelope['resource_data_description']['resource_data'])
    end

    def self.find_resource_data_description(envelope)
      envelope.fetch('resource_data_description', envelope)
    end

    def self.find_or_create_lr_document(envelope)
      if envelope.kind_of?(String)
        envelope = JSON.parse(envelope)
      end

      description = Envelope.find_resource_data_description(envelope)

      return nil unless description

      if lr_document = Models::LrDocument.find_by_doc_id(envelope['doc_ID'])
        return lr_document
      end

      parsed_format = Envelope.parse_format(envelope, description['resource_data'])

      lr_document_attrs = {
        'doc_id'              => envelope['doc_ID'],
        'active'              => description['active'],
        'doc_type'            => description['doc_type'],
        'doc_version'         => description['doc_version'],
        'identity'            => description['identity'],
        'keys'                => description['keys'],
        'payload_placement'   => description['payload_placement'],
        'payload_schema'      => description['payload_schema'],
        'resource_data_type'  => description['resource_data_type'],
        'resource_locator'    => description['resource_locator'],
        'raw_data'            => JSON.dump(envelope),
      }

      resource_data_column = case parsed_format.format
                             when :xml then 'resource_data_xml'
                             when :json then 'resource_data_json'
                             else 'resource_data_string'
                             end
      
      lr_document_attrs[resource_data_column] = parsed_format.resource_data
      lr_document_attrs['format_parsed_at'] = Time.now

      Models::LrDocument.create(lr_document_attrs)
    end

    def self.guess_format(resource_data)
      i = 0
      first_char = resource_data[i]
      while first_char == "\n"
        i += 1
        first_char = resource_data[i]
      end

      case first_char
      when '{' then :json
      when '<' then :xml
      else :text
      end
    end

    def self.parse_format(envelope, resource_data)
      format = Envelope.guess_format(resource_data)
      
      if resource_data.kind_of?(Hash)
        parsed = FormatParsers::JsonFormatParser.parse(envelope, resource_data)
      else
        parsers = case format
                  when :json then [FormatParsers::JsonFormatParser]
                  when :xml  then [FormatParsers::XmlFormatParser, FormatParsers::NsdlDcFormatParser]
                  else [FormatParsers::TextFormatParser]
                  end

        parsers.each do |parser|
          parsed = parser.parse(envelope, resource_data)
          break if parsed.valid?
        end
      end

      parsed
    end
  end
end
