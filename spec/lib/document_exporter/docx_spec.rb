require 'rails_helper'

describe DocumentExporter::Docx do
  describe '#export' do
    let(:content) { 'content' }

    subject { described_class.new.export content }

    it 'calls Pandoc wrapper' do
      expect(PandocRuby).to receive(:convert).with(content, from: :html, to: :docx)
      subject
    end

    it 'returns self' do
      expect(subject).to be_an_instance_of(described_class)
    end
  end
end
