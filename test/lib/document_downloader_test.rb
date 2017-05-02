require 'test_helper'

describe DocumentDownloader, :vcr do
  it { skip('the google authentication is not robust') }

#  let(:document_model) { LessonDocument }
#  let(:credentials) { get_google_credentials(OpenStruct.new(id: 1))}
#  let(:file_id) { '1JfwvPLtAzJ7Hwq-qOWmHAqAip0EeiObgcz_HaeveS5c' }
#  let(:gdoc) { "https://docs.google.com/document/d/#{file_id}/edit" }
#  let(:downloader) { DocumentDownloader::GDoc.new credentials, gdoc, document_model }
#
#  it 'creates a document' do
#    document = downloader.import
#    expect(document.file_id).must_equal file_id
#  end
#
#  describe 'updates a document' do
#    let(:oldname) { 'changeme' }
#    let(:existing_doc) { LessonDocument.create file_id: file_id, name: oldname }
#
#    it 'changes the name' do
#      existing_doc
#      downloader.import
#      expect(LessonDocument.count).must_equal 1
#      expect(existing_doc.reload.name).wont_equal oldname
#    end
#  end
#
#  describe 'failure' do
#    describe 'non existing document' do
#      let(:file_id) { 'fail_me' }
#      it 'returns an error if the document doesnt exists' do
#        proc {
#          downloader.import
#        }.must_raise Google::Apis::ClientError
#      end
#    end
#
#    describe 'wrong credentials' do
#      let(:credentials) { '' }
#      it 'raises an exception when the credentials are wrong' do
#        proc {
#          downloader.import
#        }.must_raise Google::Apis::AuthorizationError
#      end
#    end
#  end
end
