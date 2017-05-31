require 'rails_helper'

feature 'Welcome Page' do
  scenario 'visit welcome page and see the shoutout panel' do
    visit '/'
    expect(page).to have_css('.c-hp-panel')
  end
end
