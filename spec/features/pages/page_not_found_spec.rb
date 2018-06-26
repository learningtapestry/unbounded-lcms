# frozen_string_literal: true

require 'rails_helper'

feature 'Page Not Found' do
  background { sign_in create(:user) }

  scenario '404 page' do
    assert_not_found '/404'
  end

  scenario 'content guide page' do
    assert_not_found '/content_guides/wtf'
  end

  scenario 'media page' do
    assert_not_found '/media/wtf'
  end

  scenario 'resource page' do
    Resource.create(title: '404')
    assert_not_found '/404'
  end

  def assert_not_found(path)
    visit path
    expect(page.status_code).to eq 404
    expect(page.title).to eq 'LCMS - Page Not Found'
    expect(page.has_link?('Search page', href: '/search')).to be_truthy
  end
end
