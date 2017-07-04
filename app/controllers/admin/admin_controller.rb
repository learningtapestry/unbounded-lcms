# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    layout 'admin'

    before_action :authenticate_admin!

    private

    def authenticate_admin!
      redirect_to(root_path, alert: 'Access denied') unless current_user&.admin?
    end
  end
end
