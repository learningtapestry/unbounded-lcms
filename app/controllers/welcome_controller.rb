# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    redirect_to action: 'index', controller: 'explore_curriculum'
  end
end
