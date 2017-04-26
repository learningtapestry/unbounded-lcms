require 'test_helper'

describe DocTemplate do
  let(:html_document) do
    temp = Tempfile.new('afile.html')
    temp.write "<html><head></head><body>#{content}</body></html>"
    temp.rewind
    temp
  end

  describe 'document rendering' do
    let(:content) { '<p>sample 1</p>' }
    subject { DocTemplate::Template.parse(html_document) }

    it 'renders an html document' do
      expect(subject.render).must_equal content
    end
  end

  describe 'tag rendering' do
    describe 'default tag' do
      let(:tag) { '<p><span>[ATAG some info]</span></p>' }
      let(:content) { "#{tag}<p>info to slice</p>" }
      subject { DocTemplate::Template.parse(html_document) }
      it 'renders the default' do
        expect(subject.render).must_include content.sub(tag, '')
      end
    end

    it 'renders sections'
    it 'renders groups'
  end

end
