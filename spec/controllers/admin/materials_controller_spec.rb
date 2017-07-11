require 'rails_helper'

describe Admin::MaterialsController do
  let(:user) { create :admin }

  before { sign_in user }

  describe '#index' do
    subject { get :index }

    it { is_expected.to be_success }

    it { is_expected.to render_template :index }
  end

  describe '#new' do
    before { allow(controller).to receive(:obtain_google_credentials) }

    subject { get :new }

    it 'initiates the form object' do
      expect(MaterialForm).to receive(:new)
      subject
    end

    it { is_expected.to render_template :new }
  end
end
