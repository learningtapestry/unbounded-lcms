# frozen_string_literal: true

module GoogleAuth
  extend ActiveSupport::Concern

  attr_reader :google_credentials

  def obtain_google_credentials(options = {})
    @google_credentials = service.credentials

    redirect_to service.authorization_url(options) unless @google_credentials
  end

  private

  def service
    @service ||= GoogleAuthService.new(self)
  end
end
