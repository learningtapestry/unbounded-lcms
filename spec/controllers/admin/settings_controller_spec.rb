# frozen_string_literal: true

require 'rails_helper'

describe Admin::SettingsController do
  let(:user) { create :admin }

  before { sign_in user }

  it 'toggle editing_enabled' do
    expect(Settings[:editing_enabled]).to be true
    patch :toggle_editing_enabled
    expect(Settings[:editing_enabled]).to be false
    expect(response).to redirect_to(:admin_resources)
  end
end
