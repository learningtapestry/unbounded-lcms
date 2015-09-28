require 'content/models'

module Lt
  class AdminController < LtController
    before_action :authenticate_admin!
  end
end
