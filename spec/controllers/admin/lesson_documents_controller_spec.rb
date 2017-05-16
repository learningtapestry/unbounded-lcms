require 'rails_helper'

describe Admin::LessonDocumentsController do
  let(:user) { create :admin }

  before { sign_in user }

  describe '#new' do
    before { allow(controller).to receive(:obtain_google_credentials) }

    subject { get :new }

    it 'initiates the form object' do
      expect(LessonDocumentForm).to receive(:new).with(LessonDocument)
      subject
    end

    it { is_expected.to render_template :new }
  end
end
