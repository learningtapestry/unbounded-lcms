# frozen_string_literal: true

require 'rails_helper'

# NOTE temporary redirects to explore curriculum
feature 'Welcome Page' do
  xscenario 'visit welcome page and see the shoutout panel' do
    visit '/'
    expect(page).to have_css('.c-hp-panel')
  end
end
