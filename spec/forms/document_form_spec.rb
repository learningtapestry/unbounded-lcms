# frozen_string_literal: true

require 'rails_helper'

describe DocumentForm do
  let(:klass) { Document }
  let(:form) { described_class.new klass, params }

  describe '#save' do
    subject { form.save }

    context 'when is valid' do
      let(:document) do
        stubs = {
          activate!: nil,
          original_content: nil,
          update!: nil,
          document_parts: double('parts', delete_all: true)
        }
        instance_double Document, stubs
      end
      let(:downloader) { instance_double 'DocumentDownloader::GDoc', import: document }
      let(:link) { 'doc-url' }
      let(:material_ids) { [1, 3] }
      let(:params) { { link: link } }
      let(:parsed_document) do
        stubs = {
          activity_metadata: [{ 'material_ids' => material_ids }],
          agenda: [],
          css_styles: '',
          foundational_metadata: '',
          metadata: '',
          render: '',
          toc: '',
          parts: []
        }
        instance_double DocTemplate::Template, stubs
      end

      before do
        allow(DocumentDownloader::GDoc).to receive(:new).with(nil, link, Document).and_return(downloader)
        allow(DocTemplate::Template).to receive(:parse).and_return(parsed_document)
        allow(DocumentPdfGenerator).to receive(:materials_for)
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

      it 'queues job to process equations' do
        expect(DocumentPdfGenerator).to receive(:materials_for).with(document)
      end

      after { subject }
    end

    context 'when is invalid' do
      let(:params) { {} }

      it { is_expected.to be_falsey }
    end
  end
end
