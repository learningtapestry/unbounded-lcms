class UnboundedController < ApplicationController
  layout 'unbounded'
  before_action { find_organization(:unbounded) }
end
