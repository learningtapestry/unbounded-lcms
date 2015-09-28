require 'content/models'

module AuthenticatesAdmin
  def authenticate_admin!
    authenticate_user!

    unless current_user.has_role?(@organization, Content::Models::Role.named(:admin))
      raise "User is not an admin for #{@organization.name}."
    end
  end
end
