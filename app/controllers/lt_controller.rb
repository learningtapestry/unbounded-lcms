class LtController < ApplicationController
  before_action { find_organization(:lt) }
end
