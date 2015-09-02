module Unbounded
  class AdminController < UnboundedController
    before_action :authenticate_admin!

    def authenticate_admin!
      authenticate_user!

      unless current_user.has_role?(@unbounded, Content::Models::Role.named(:admin))
        raise "User is not an admin for UnboundEd."
      end
    end
  end  
end
