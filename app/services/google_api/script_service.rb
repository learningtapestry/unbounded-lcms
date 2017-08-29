# frozen_string_literal: true

module GoogleApi
  class ScriptService < Base
    SCRIPT_ID = ENV.fetch('GOOGLE_APPLICATION_SCRIPT_ID')

    def execute(id)
      # Create an execution request object.
      request = Google::Apis::ScriptV1::ExecutionRequest.new(
        function: 'postProcessingUB',
        parameters: [id, gdoc_template_id, document.cc_attribution, document.full_breadcrumb, document.short_url]
      )
      response = service.run_script(SCRIPT_ID, request)
      return unless response.error
      # The API executed, but the script returned an error.
      error = response.error.details[0]
      msg = String.new("Script error message: #{error['errorMessage']}\n")
      if error['scriptStackTraceElements']
        msg << 'Script error stacktrace:'
        error['scriptStackTraceElements'].each do |trace|
          msg << "\t#{trace['function']}: #{trace['lineNumber']}"
        end
      end
      raise Google::Apis::Error, msg
    end

    protected

    def gdoc_template_id
      ENV.fetch("GOOGLE_APPLICATION_TEMPLATE_#{document&.orientation&.upcase || 'PORTRAIT'}")
    end
  end
end
