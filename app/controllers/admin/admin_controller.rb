module Admin
  class AdminController < ApplicationController
    layout 'admin'

    before_action :authenticate_admin!

    private

    def authenticate_admin!
      authenticate_user!
      raise 'User is not an admin.' unless current_user.admin?
    end
  end
end
