require 'nokogiri'
require 'json'
require 'content/models/concerns/normalizable'
require 'content/models/source_document/source_document'

module Content
  class LrDocument < ActiveRecord::Base
    SOURCE_TYPE = :lr
    
    include Normalizable
    include SourceDocument::Document
    
    normalize_attr :keys, ->(val) { Array.wrap(val).map { |v| v.strip.downcase } }
    normalize_attr :payload_schema, ->(val) { Array.wrap(val).map { |v| v.strip.downcase } }

    def self.where_schema(schema)
      schema = Array.wrap(schema).map(&:to_s).inspect.gsub('"', '\'')
      selector = "#{table_name}.payload_schema ?| array[#{schema}]"
      where(selector)
    end

    def format
      return :text if !resource_data_string.nil?
      return :xml  if !resource_data_xml.nil?
      return :json if !resource_data_json.nil?
      nil
    end

    def resource_data_content
      return resource_data_string if !resource_data_string.nil?
      return Nokogiri::XML(resource_data_xml) if !resource_data_xml.nil?
      return resource_data_json if !resource_data_json.nil?
      nil
    end
  end
end
