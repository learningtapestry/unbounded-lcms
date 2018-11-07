# frozen_string_literal: true

require 'google/apis/drive_v3'

namespace :cleanup do
  namespace :materials do
    def credentials
      GoogleApi::AuthCLIService.new.credentials
    end
  end
end
