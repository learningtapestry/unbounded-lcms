class RegistrationsController < Devise::RegistrationsController

  before_action :redirect_to_root

  protected

  def redirect_to_root
    if user_signed_in?
      redirect_to root_path
    else
      redirect_to new_user_session_path
    end  
  end

end
