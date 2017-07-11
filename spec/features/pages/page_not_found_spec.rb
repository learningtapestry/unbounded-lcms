require 'rails_helper'

feature 'Page Not Found' do
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
    CurriculumTree.default.present? || create(:curriculum_tree)
    Resource.create(title: '404')
    assert_not_found '/404'
  end

  def assert_not_found(path)
    visit path
    expect(page.status_code).to eq 404
    expect(page.title).to eq 'UnboundEd - Page Not Found'
    expect(page.has_link?('Search page', href: '/search')).to be_truthy
  end
end
