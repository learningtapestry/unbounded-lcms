# frozen_string_literal: true

require 'rails_helper'

describe Admin::DocumentsController do
  let(:user) { create :admin }

  before { sign_in user }

  describe '#create' do
    let(:credentials) { double }
    let(:document) { create :document }
    let(:form) { instance_double('DocumentForm', document: document, save: valid) }
    let(:params) { { link: 'link', link_fs: 'link_fs', reimport: '1' } }
    let(:valid) { true }

    before do
      allow(controller).to receive(:obtain_google_credentials)
      allow(controller).to receive(:google_credentials).and_return(credentials)
      allow(::DocumentForm).to receive(:new).and_return(form)
    end

    subject { post :create, document_form: params }

    it 'creates DocumentForm object' do
      expect(DocumentForm).to receive(:new).with(params, credentials)
      subject
    end

    it 'redirects to document' do
      subject
      expect(response).to redirect_to document
    end

    context 'when there is an error' do
      let(:valid) { false }

      it { is_expected.to render_template :new }
    end
  end

  describe '#destroy' do
    let!(:document) { create :document }

    subject { delete :destroy, id: document.id }

    it 'deletes the document' do
      expect { subject }.to change(Document, :count).by(-1)
    end
  end

  describe '#new' do
    before { allow(controller).to receive(:obtain_google_credentials) }

    subject { get :new }

    it 'initiates the form object' do
      expect(DocumentForm).to receive(:new)
      subject
    end

    it { is_expected.to render_template :new }
  end
end
