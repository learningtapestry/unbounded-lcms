# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    layout 'admin'

    before_action :authenticate_admin!

    def whoami
      render text: "stack=#{ENV['CLOUD66_STACK_NAME']}<br/>env=#{ENV['CLOUD66_STACK_ENVIRONMENT']}"
    end

    private

    def authenticate_admin!
      redirect_to(root_path, alert: 'Access denied') unless current_user&.admin?
    end
  end
end
