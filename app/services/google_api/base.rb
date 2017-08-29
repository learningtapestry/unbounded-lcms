# frozen_string_literal: true

module GoogleApi
  class Base
    attr_reader :service, :document, :options

    def initialize(service, document, options = {})
      @service  = service
      @document = document
      @options  = options
    end
  end
end
