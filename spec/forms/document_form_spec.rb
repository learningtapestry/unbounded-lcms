# frozen_string_literal: true

require 'rails_helper'

describe DocumentForm do
  let(:credentials) { double }
  let(:form) { described_class.new params, credentials }

  describe '#save' do
    let(:document) { create :document}
    let(:service) { instance_double('DocumentBuildService', build_for: document) }

    subject { form.save }

    context 'when is valid' do
      let(:link) { 'doc-url' }
      let(:params) { { link: link } }

      before do
        allow(DocumentGenerator).to receive(:generate_for)
        allow(DocumentBuildService).to receive(:new).and_return(service)
      end

      it 'creates DocumentBuildService object' do
        expect(DocumentBuildService).to receive(:new).with(credentials).and_return(service)
        subject
      end

      it 'builds the document' do
        subject
        expect(form.document).to eq document
      end

      it 'queues job to generate PDF and GDoc' do
        expect(DocumentGenerator).to receive(:generate_for).with(document)
        subject
      end

      context 'when that is re-import operation' do
        before { params.merge!(link_fs: 'ink_fs', reimport: '1') }

        it 'calls service sequentently to import both type of links' do
          expect(service).to receive(:build_for).with(params[:link])
          expect(service).to receive(:build_for).with(params[:link_fs], expand: true)
          subject
        end
      end
    end

    context 'when is invalid' do
      let(:params) { {} }

      it { is_expected.to be_falsey }
    end
  end
end
