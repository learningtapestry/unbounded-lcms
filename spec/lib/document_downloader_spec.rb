require 'rails_helper'

describe DocumentDownloader::GDoc do
  let(:access_token) { 'token' }
  let(:credentials) { double access_token: access_token }
  let(:downloader) { described_class.new credentials, file_url, target_class }
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

    context 'when document contains Google Drawings objects' do
      let(:document) { LessonDocument.last }
      let(:drawing_encoded) { 'body' }
      let(:drawing_url) { 'https://docs.google.com/drawings/image?id=s_uiJ2KNBacy7Mt2DqQn5aQ&amp;rev=1&amp;h=125&amp;w=345&amp;ac=1' }
      let(:drawing_url_clear) { CGI.unescapeHTML drawing_url }
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }
      let(:response) { OpenStruct.new content_type: 'image/png' }
      let(:service) { double export_file: file_content }

      before do
        allow_any_instance_of(described_class).to receive(:content).and_call_original
        allow_any_instance_of(described_class).to receive(:service).and_return(service)

        allow(HTTParty).to receive(:get).with(drawing_url_clear, headers: headers).and_return(response)
        allow(Base64).to receive(:encode64).with(response).and_return(drawing_encoded)
      end

      context 'with single url' do
        let(:file_content) { %( <p><span><img alt="" src="#{drawing_url}" title=""></span></p><div> ) }

        it 'fetches them' do
          expect(HTTParty).to receive(:get).with(drawing_url_clear, headers: headers)
          subject
        end

        it 'encodes them using Base64' do
          expect(Base64).to receive(:encode64).with(response)
          subject
        end

        it 'substitutes the original URL' do
          subject
          expect(document.original_content).to_not include(drawing_url)
          expect(document.original_content).to_not include(drawing_url_clear)
          expect(document.original_content).to include(drawing_encoded)
        end
      end

      context 'with multiple url' do
        let(:drawing_url1)       { 'https://docs.google.com/drawings/image?id=s_23J2KNBacy7Mt2DqQn5aQ&amp;rev=1&amp;h=345' }
        let(:drawing_url1_clear) { CGI.unescapeHTML drawing_url1 }
        let(:file_content) do
          <<-HTML
            <span><img src="#{drawing_url}">
            </span><div><img src="#{drawing_url1}">
            </div><div><img src="#{drawing_url}"></div>
          HTML
        end

        before do
          allow(HTTParty).to receive(:get).with(drawing_url1_clear, headers: headers).and_return(response)
        end

        it 'substitutes the original URLS' do
          expect(HTTParty).to receive(:get).twice
          subject
          expect(document.original_content).to_not include(drawing_url)
          expect(document.original_content).to_not include(drawing_url_clear)
          expect(document.original_content).to_not include(drawing_url1)
          expect(document.original_content).to_not include(drawing_url1_clear)
          expect(document.original_content.scan(drawing_encoded).size).to eq 3
        end
      end
    end
  end
end
