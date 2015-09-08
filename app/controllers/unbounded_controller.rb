class UnboundedController < ApplicationController
  include Content::Models

  layout 'unbounded'

  before_action :setup_unbounded_org
  
  def setup_unbounded_org
    @unbounded = Content::Models::Organization.find_by(name: 'UnboundEd')
  end
end
