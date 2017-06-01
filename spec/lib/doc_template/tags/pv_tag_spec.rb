require 'rails_helper'

describe DocTemplate::Tags::PvTag do
  let(:node) { Nokogiri::HTML(original_content).at_xpath('*//p') }
  let(:original_content) { "<p><span>[PV: </span><span >#{pv_value}</span><span>]</span></p>" }
  let(:pv_value) { 'Millions' }
  let(:params) { { value: pv_value } }
  let(:tag) { described_class.new }

  subject { tag.parse(node, params).render.to_html }

  it 'removes tag after rendering' do
    expect(subject).to_not include('[PV:')
  end

  it 'renders corresponding template' do
    expect(ERB).to receive_message_chain(:new, :result).and_return('')
    subject
  end

  context 'when config for tag value does not exist' do
    before { allow(described_class).to receive(:config).and_return({}) }

    it 'does not render template' do
      expect(ERB).to_not receive(:new)
      subject
    end
  end
end
