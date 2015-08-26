require 'uri'
require 'thread/pool'
require 'http'
require 'addressable/uri'
require 'openssl'

require 'content/models'

module Content
  module Enrichers
    class UrlStatusChecker
      CHECK_EVERY = 1.month
      TIMEOUT = 5

      def self.valid_url?(url)
        begin
          parsed = Addressable::URI.parse(url)
          %w(http https).include?(parsed.scheme)
        rescue Addressable::URI::InvalidURIError
          false
        end
      end

      def self.check_statuses(check_every = CHECK_EVERY)
        pool = Thread.pool(150)

        Content::Url.stale(check_every).find_each do |loc|

          next unless valid_url?(loc.url)

          ssl_context = OpenSSL::SSL::SSLContext.new
          ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE

          pool.process {
            http_status = nil

            begin
              http_status = HTTP
              .timeout(:per_operation, write: 10, connect: 10, read: 500)
              .head(loc.url, ssl_context: ssl_context)
              .status
              .code

              LT.env.logger.info("Checked URL #{loc.id} (#{loc.url}) with status code #{http_status}.")
            rescue => e
              LT.env.logger.error("Failed for URL #{loc.id} (#{loc.url}): #{e.message}")
            end

            ActiveRecord::Base.connection_pool.with_connection {
              Content::Url
                .find(loc.id)
                .update_attributes(
                  checked_at: Time.now,
                  http_status: http_status
                )
            }
          }
        end

        pool.shutdown
      end
    end
  end
end
