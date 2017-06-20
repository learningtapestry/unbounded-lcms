require 'rails_helper'

describe DocTemplate::Tags::ColumnsTag do
  let(:columns_count) { '2' }
  let(:end_value) { DocTemplate::Tags::ColumnsTag::END_VALUE }
  let(:node) do
    html = Nokogiri::HTML original_content
    html.at_xpath('*//p')
  end
  let(:original_content) do
    <<-HTML
      <p><span>[#{tag_name}: #{columns_count}]</span></p><p><span>10 tens =; 1 thousand; </span></p><p><span></span></p><p><span></span></p><p>
      <span>10 hundreds =; <p><span>[qrd: https://google.com]<span></p>1 ten;</span></p><p><span></span></p><p><span></span></p>
      <p><span>10 ones =; 1 hundred;</span></p><p><span>3 ones=;; </span></p>
      <p><span>[#{tag_name}: #{end_value}]</span></p><p>NOT THIS!</p>
    HTML
  end
  let(:tag) { described_class.new }
  let(:tag_name) { DocTemplate::Tags::ColumnsTag::TAG_NAME }

  subject { tag.parse(node, value: columns_count).render.to_html }

  it 'removes original node' do
    expect(subject).to_not include("[#{tag_name}: #{columns_count}]")
  end

  it 'adds wrapper' do
    expect(subject).to match(/^<div class="o-ld-columns">/)
  end

  it 'does not includes nodes after the end tag' do
    expect(subject).to_not include('<p>NOT THIS!</p>')
  end

  it 'parses nested tags' do
    expect(subject).to include('<a href="https://google.com"')
  end

  context 'when there are image elements' do
    let(:original_content) do
      <<-HTML
        <p><span>[#{tag_name}: #{columns_count}]</span></p><p><span>10 tens =; 1 thousand; </span></p><p><span></span></p><p><span></span></p><p>
        <span><img src="fake://src">10 hundreds =; 1 ten;</span></p><p><span></span></p><p><span></span></p><p><span>10 ones =; 1 hundred;</span>
        </p><p><span>3 ones=;; </span></p><p><span>[#{tag_name}: #{end_value}]</span></p>
      HTML
    end

    it 'preserves them' do
      expect(subject).to include('<img')
    end
  end
end
