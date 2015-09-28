module Unbounded
  class AdminController < UnboundedController
    layout 'unbounded_admin'
    before_action :authenticate_admin!
  end  
end
