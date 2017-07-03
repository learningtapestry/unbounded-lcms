class RegistrationsController < Devise::RegistrationsController
  before_action :redirect_to_root

  protected

  def redirect_to_root
    redirect_to(user_signed_in? ? root_path : new_user_session_path)
  end
end
