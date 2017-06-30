require 'rails_helper'

describe Admin::DocumentsController do
  let(:user) { create :admin }

  before { sign_in user }

  describe '#new' do
    before { allow(controller).to receive(:obtain_google_credentials) }

    subject { get :new }

    it 'initiates the form object' do
      expect(DocumentForm).to receive(:new).with(Document)
      subject
    end

    it { is_expected.to render_template :new }
  end
end
