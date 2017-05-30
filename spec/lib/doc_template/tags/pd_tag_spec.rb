require 'rails_helper'

describe DocTemplate::Tags::PdTag do
  let(:description) { 'description' }
  let(:node) { Nokogiri::HTML(original_content).at_xpath('*//p') }
  let(:original_content) { "<p><span>[PD: #{url}; #{title}; </span><span>#{description}]</span></p><p><span>" }
  let(:params) do
    {
      metadata: OpenStruct.new(resource_subject: 'ela'),
      value: [url, title, description].join('; ')
    }
  end
  let(:tag) { described_class.new }
  let(:title) { 'title' }
  let(:url) { 'url' }

  before { allow_any_instance_of(described_class).to receive(:embeded_object_for).and_return(double) }

  subject { tag.parse(node, params).render.to_html }

  it 'renders corresponding template' do
    expect(ERB).to receive_message_chain(:new, :result).and_return('')
    subject
  end

  context 'when tag contains unsupported link' do
    before { allow_any_instance_of(described_class).to receive(:embeded_object_for) }

    it 'does not render template' do
      expect(ERB).to_not receive(:new)
      subject
    end
  end

  context 'when resource with such url exist' do
    let!(:resource) { create :resource, teaser: 'teaser', url: url }

    before do
      allow_any_instance_of(described_class).to receive(:embeded_object_for).and_return({})
    end

    context 'when tag does not contain title' do
      let(:title) { '' }

      it 'uses resource title' do
        subject
        expect(tag.instance_variable_get(:@title)).to eq resource.title
      end
    end

    context 'when tag does not contain description' do
      let(:description) { '' }

      it 'uses resource teaser' do
        subject
        expect(tag.instance_variable_get(:@description)).to eq resource.teaser
      end
    end
  end
end
