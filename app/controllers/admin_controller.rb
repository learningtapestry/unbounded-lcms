require 'content/models'

class AdminController < ApplicationController
  before_action :find_organization, :authenticate_admin!

  def find_organization
    @lt = Organization.lt
  end

  def authenticate_admin!
    authenticate_user!

    unless current_user.has_role?(@lt, Role.named(:admin))
      raise "User is not a LearningTapestry admin."
    end
  end
end
