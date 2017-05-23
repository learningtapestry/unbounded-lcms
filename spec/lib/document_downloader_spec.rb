require 'rails_helper'

describe DocumentDownloader::GDoc do
  let(:downloader) { described_class.new nil, file_url, target_class }
  let(:file_id) { '16sDahoxlTIoGwp8SrtrGDao98GQuZMQnoc-7PKOUxUM' }
  let(:file_url) { "https://docs.google.com/document/d/#{file_id}/edit" }
  let(:target_class) { LessonDocument }

  describe '#import' do
    let(:content) { 'content' }
    let(:file) { double 'Hash', params}
    let(:params) do
      {
        name: 'name',
        modified_time: 'modified_time',
        last_modifying_user: 'last_modifying_user',
        last_author_email: 'last_author_email',
        last_author_name: 'last_author_name',
        version: 'version'
      }
    end

    before do
      allow_any_instance_of(described_class).to receive(:content).and_return(content)
      allow_any_instance_of(described_class).to receive(:file).and_return(file)
    end

    subject { downloader.import }

    it 'initialize instance of object' do
      expect(target_class).to receive(:find_or_initialize_by).with(file_id: file_id).and_call_original
      subject
    end

    it 'saves it' do
      subject
      expect(target_class.count).to eql 1
    end

    it 'returns it' do
      expect(subject).to be_a target_class
    end
  end
end
