# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  private

  def after_inactive_sign_up_path_for(_)
    new_user_session_path
  end
end
