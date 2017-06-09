require 'rails_helper'

describe DocTemplate::Tags::InsetTag do
  let(:original_content) do
    <<-HTML
      <p><span>[inset]</span></p>
      <p><span style="font-weight:700;">displeases, </span><span style="font-style:italic;font-weight:700">adj</span><span style="font-weight:700;">.</span><span> Feeling unhappy or bothered about something.<br>Example: It displeases the baseball players when their game is canceled because of rain.<br>Variation(s): none</span></p>
      <p><span style="font-weight:700;">enchanted, </span><span style="font-style:italic;font-weight:700">adj.</span><span> As if under a magic spell<br></span><span style="font-style:italic;">Example:</span><span> Kate and Jack knew they were in an enchanted forest because there were jewels growing on the trees.<br></span><span style="font-style:italic;">Variation(s):</span><span> none</span></p>
      <p><span>[inset:end]</span></p><p>NOT THIS!</p>
    HTML
  end
  let(:tag) { described_class.new }

  let(:node) do
    html = Nokogiri::HTML original_content
    html.at_xpath('*//p')
  end

  subject { tag.parse(node, value: '').render.to_html }

  it 'removes original node' do
    expect(subject).to_not include('[inset]')
  end

  it 'adds inset class to paragraphs' do
    expect(subject).to match(/class=".*inset.*"/)
  end

  it 'does not includes nodes after the end tag' do
    expect(subject).to_not include('<p class=" inset">NOT THIS!</p>')
  end

  it 'preserves styling' do
    expect(subject).to match(/class=".*text-bold.*"/)
    expect(subject).to match(/class=".*text-italic.*"/)
  end
end
