# frozen_string_literal: true

module GoogleApi
  class Base
    attr_reader :service, :document, :options

    class << self
      private :new

      def build(klass, document, options = {})
        new(document: document, klass: klass, options: options)
      end

      def build_with(service, document, options = {})
        new(document: document, options: options, service: service)
      end
    end

    private

    def initialize(document:, klass: nil, options: {}, service: nil)
      @document = document
      @options  = options

      if service.present?
        @service = service
      else
        @service = klass.new
        @service.authorization = credentials
      end
    end

    def credentials
      @credentials ||= GoogleApi::AuthCLIService.new.credentials
    end
  end
end
