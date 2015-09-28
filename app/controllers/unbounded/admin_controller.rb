module Unbounded
  class AdminController < UnboundedController
    before_action :authenticate_admin!
  end  
end
