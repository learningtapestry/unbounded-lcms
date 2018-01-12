# frozen_string_literal: true

module GoogleCredentials
  extend ActiveSupport::Concern

  def google_credentials(user_id)
    service = GoogleAuthService.new(nil)
    fake_request = OpenStruct.new(session: {})
    service.authorizer.get_credentials(user_id, fake_request)
  end
end
