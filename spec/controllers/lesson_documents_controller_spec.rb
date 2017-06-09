require 'rails_helper'

describe LessonDocumentsController do
  let(:document) { create :lesson_document }
  let(:metadata) { instance_double 'DocTemplate::Objects::BaseMetadata', title: title }
  let(:title) { 'title' }

  describe '#export_gdoc' do
    let(:exporter) { instance_double 'DocumentExporter::Gdoc', url: url }
    let(:file_id) { 'fileid' }
    let(:url) { 'url' }

    before do
      allow(controller).to receive(:obtain_google_credentials)
      allow(DocTemplate::Objects::BaseMetadata).to receive(:build_from).and_return(metadata)
      allow(DocumentExporter::Gdoc).to receive_message_chain(:new, :export).and_return(exporter)
    end

    subject { get :export_gdoc, id: document.id }

    it 'renders document content into a string' do
      expect(controller).to receive(:render_to_string).with(layout: 'ld_gdoc')
      subject
    end

    it 'calls DocumentExporter' do
      expect(DocumentExporter::Gdoc).to receive_message_chain(:new, :export)
      subject
    end

    it 'redirects to the final Google Doc' do
      expect(subject).to redirect_to url
    end
  end
end
