require 'rails_helper'

describe Search::Document do
  let(:resource) { create :resource }
  let(:content_guide) { create :content_guide }

  it 'build_from resource' do
    doc = Search::Document.build_from(resource)
    expect(doc.title).to eq 'Test Resource'
    expect(doc.doc_type).to eq 'lesson'
    expect(doc.breadcrumbs).to eq 'ELA / G2 / M1 / U1 / lesson 1'
  end

  it 'build_from content_guide' do
    doc = Search::Document.build_from(content_guide)
    expect(doc.title).to eq 'Test ContentGuide'
    expect(doc.doc_type).to eq 'content_guide'
  end
end
