module GoogleAuth
  extend ActiveSupport::Concern

  attr_reader :google_credentials

  def obtain_google_credentials
    @google_credentials = service.credentials

    redirect_to service.authorization_url unless @google_credentials
  end

  private

  def service
    @service ||= GoogleAuthService.new(self)
  end
end
