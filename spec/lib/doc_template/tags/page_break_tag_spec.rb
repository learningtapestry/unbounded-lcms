require 'rails_helper'

describe DocTemplate::Tags::PageBreakTag do
  let(:node) { Nokogiri::HTML(original_content).at_xpath('*//p') }
  let(:original_content) { '<p><span>[page-break]</span></p>' }
  let(:tag) { described_class.new }
  let(:cls) { 'u-pdf-alwaysbreak' }

  subject { tag.parse(node, {}).content }

  it 'substitutes the tag' do
    expect(subject).to_not include '[page-break]'
    expect(subject).to include %(<div class="#{cls}">)
  end
end
