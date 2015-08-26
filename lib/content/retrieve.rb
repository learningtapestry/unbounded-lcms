require 'open-uri'
require 'json'
require 'nokogiri'
require 'set'
require 'content/envelope'
require 'content/models'

module Content
  module Retrieve class << self
    # Purpose: 
    #   Extract metadata from HTTP/API call to a Learning Registry extraction endpoint for a range of dates

    DEFAULT_START_DATE = Date.parse('2001-01-01')
    HTTP_MAX_RETRIES_COUNT = 3

    # Purpose: Retrieve envelopes from Learning Registry and store them in Postgres
    # Options:
    #   :node - FQDN URL to server to pull from (required)
    #   :from_date - Date string indicating when to start pulling resources
    #   :until_date - Date string indicating when to stop pulling resources (optional)
    #      default: Date.today
    def retrieve_range(options = {})
      raise LT::ParameterMissing if options[:node].nil?
      start_date = LrDocumentLog.last.try(:newest_import_date) || DEFAULT_START_DATE

      options[:from_date] = start_date unless options[:from_date]
      options[:until_date] = Date.today unless options[:until_date]

      token = nil
      records = Set.new

      while true
        target_url = harvest_url(options)

        json_data = get_json_data(target_url)
        if !json_data or !json_data.kind_of?(Hash) or !json_data['documents'].kind_of?(Array)
          LT.env.logger.error("#{self.name}: Failed to parse JSON data from #{target_url}.")
          break
        end

        json_data['documents'].each do |envelope|
          records << Envelope.find_or_create_lr_document(envelope)
        end # json_data['documents'].each do |doc|

        token = options[:token] = json_data['resumption_token']
        break if token.nil? # exit when resumption token is empty
      end # while true

      LrDocumentLog.create(
        'action'              => 'lr_import',
        'newest_import_date'  => options[:until_date],
      )

      records
    end # retrieve

    # parse JSON data from 3rd party api url
    def get_json_data(url)
      tries = 0

      # open 3rd party api url
      begin
        buffer = open(url).read
      rescue OpenURI::HTTPError => e
        LT.env.logger.error("#{self.name}: Failed to open #{url}, message: #{e.message}.")
        tries += 1

        if tries > HTTP_MAX_RETRIES_COUNT
          LT.env.logger.error("#{self.name}: Failed to extract data from #{url}.")
          return
        end
      end

      # parse JSON data
      begin
        json_data = JSON.parse(buffer)  
      rescue JSON::ParserError
        LT.env.logger.error("#{self.name}: Failed to parse JSON data from #{url}.")
        return 
      end

      json_data
    end


    def harvest_url(options)
      node = options[:node]
      from_date = options[:from_date]
      until_date = options[:until_date]
      token = options[:token]
      url = "#{node}/slice?from=#{from_date.strftime('%Y-%m-%d')}"
      url += "&#{until_date.strftime('%Y-%m-%d')}" if until_date
      url += "&resumption_token=#{token}" if token

      url
    end
  end; end
end
