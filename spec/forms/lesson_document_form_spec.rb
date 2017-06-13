require 'rails_helper'

describe LessonDocumentForm do
  let(:klass) { LessonDocument }
  let(:form) { described_class.new klass, params }

  describe '#save' do
    subject { form.save }

    context 'when is valid' do
      let(:document) do
        stubs = {
          activate!: nil,
          original_content: nil,
          update!: nil
        }
        instance_double LessonDocument, stubs
      end
      let(:downloader) { instance_double 'DocumentDownloader::GDoc', import: document }
      let(:link) { 'doc-url' }
      let(:params) { { link: link } }
      let(:parsed_document) do
        stubs = {
          activity_metadata: '',
          css_styles: '',
          foundational_metadata: '',
          metadata: '',
          render: '',
          toc: ''
        }
        instance_double DocTemplate::Template, stubs
      end

      before do
        allow(DocumentDownloader::GDoc).to receive(:new).with(nil, link, LessonDocument).and_return(downloader)
        allow(DocTemplate::Template).to receive(:parse).and_return(parsed_document)
        allow(LessonGenerateDocxJob).to receive(:perform_later)
        allow(LessonGeneratePdfJob).to receive(:perform_later)
      end

      it 'downloads the document' do
        expect(downloader).to receive(:import)
      end

      it 'parses the document' do
        expect(DocTemplate::Template).to receive(:parse)
      end

      it 'activates the document' do
        expect(document).to receive(:activate!)
      end

      # NOTE: Temporary disable DOCX generation - need to solve
      # few issues on the server side
      # it 'queues job to generate Docx' do
      #   expect(LessonGenerateDocxJob).to receive(:perform_later).with(document)
      # end
      xit 'queues job to generate Docx' do
        expect(LessonGenerateDocxJob).to receive(:perform_later).with(document)
      end

      it 'queues job to generate PDF' do
        expect(LessonGeneratePdfJob).to receive(:perform_later).with(document, pdf_type: 'full')
        expect(LessonGeneratePdfJob).to receive(:perform_later).with(document, pdf_type: 'sm')
        expect(LessonGeneratePdfJob).to receive(:perform_later).with(document, pdf_type: 'tm')
      end

      after { subject }
    end

    context 'when is invalid' do
      let(:params) { {} }

      it { is_expected.to be_falsey }
    end
  end
end
