require 'rails_helper'

describe Admin::LessonDocumentsController do
  let(:user) { create :admin }

  before { sign_in user }

  describe '#export' do
    let(:document) { create :lesson_document }
    let(:exporter) { instance_double 'DocumentExporter::GDoc', url: url }
    let(:file_id) { 'fileid' }
    let(:metadata) { instance_double 'DocTemplate::Objects::BaseMetadata', title: title }
    let(:title) { 'title' }
    let(:url) { 'url' }

    before do
      allow(controller).to receive(:obtain_google_credentials)
      allow(DocTemplate::Objects::BaseMetadata).to receive(:build_from).and_return(metadata)
      allow(DocumentExporter::GDoc).to receive_message_chain(:new, :export).and_return(exporter)
    end

    subject { get :export, id: document.id }

    it 'renders document content into a string' do
      expect(controller).to receive(:render_to_string).with(layout: 'ld_gdoc')
      subject
    end

    it 'calls DocumentExporter' do
      expect(DocumentExporter::GDoc).to receive_message_chain(:new, :export)
      subject
    end

    it 'redirects to the final Google Doc' do
      expect(subject).to redirect_to url
    end
  end

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
