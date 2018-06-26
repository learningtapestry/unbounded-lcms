# frozen_string_literal: true

require 'rails_helper'

feature 'Page Titles' do
  scenario 'home page' do
    visit '/'
    expect(current_path).to eq '/users/sign_in'
  end

  xscenario 'about page' do
    create(:page, :about)
    visit '/about'
    expect(current_path).to eq '/users/sign_in'
  end

  context 'logged in as user' do
    background { sign_in create :user }

    scenario 'home page' do
      visit '/'
      expect(page.title).to include('LCMS')
    end

    xscenario 'about page' do
      visit '/about'
      expect(page.title).to include(about.title)
    end

    scenario 'tos page' do
      tos = create(:page, :tos)
      visit '/tos'
      expect(page.title).to include(tos.title)
    end

    scenario 'auth pages' do
      logout

      visit '/users/password/new'
      expect(page.title).to include('Forgot Your Password?')

      visit '/users/sign_in'
      expect(page.title).to include('Log In')

      visit '/users/sign_up'
      expect(page.title).to include('Create Account')
    end
  end

  context 'logged in as admin' do
    background { sign_in create :admin }

    scenario 'about page' do
      visit '/admin'
      expect(page.title).to include('Admin')
    end

    scenario 'admin page pages' do
      tos = create(:page, :tos)

      visit '/admin/pages'
      expect(page.title).to include('Pages')

      visit '/admin/pages/new'
      expect(page.title).to include('New Page')

      visit "/admin/pages/#{tos.id}/edit"
      expect(page.title).to include("Edit #{tos.title} Page")
    end

    scenario 'admin resources pages' do
      resource = create(:resource)

      visit '/admin/resources'
      expect(page.title).to include('Content Administration')

      visit '/admin/resources/new'
      expect(page.title).to include('New Resource')

      visit "/admin/resources/#{resource.id}/edit"
      expect(page.title).to include("Edit #{resource.title}")
    end

    scenario 'admin staff_member pages' do
      member = create :staff_member

      visit '/admin/staff_members'
      expect(page.title).to include('Staff Members')

      visit '/admin/staff_members/new'
      expect(page.title).to include('New Staff Member')

      visit "/admin/staff_members/#{member.id}/edit"
      expect(page.title).to include("LCMS - #{member.name}")
    end
  end
end
