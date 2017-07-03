require 'rails_helper'

describe PagesController do
  before(:all) { Rake::Task['db:seed:pages'].invoke }

  describe 'about page' do
    before { get :show_slug, slug: 'about' }
    it { expect(response).to be_success }
  end

  describe 'about_people page' do
    before { get :show_slug, slug: 'about_people' }
    it { expect(response).to be_success }
  end

  describe 'tos page' do
    before { get :show_slug, slug: 'tos' }
    it { expect(response).to be_success }
  end

  describe 'privacy page' do
    before { get :show_slug, slug: 'privacy' }
    it { expect(response).to be_success }
  end

  describe 'leadership page' do
    before { get :leadership }
    it { expect(response).to be_success }
  end
end
