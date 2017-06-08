require 'rails_helper'

describe DocTemplate::Tags::ColumnsTag do
  let(:original_content) do
    <<-HTML
      <p><span>[#{tag_name}: #{columns_count}]</span></p><p><span>10 tens =; 1 thousand; </span></p><p><span></span></p><p><span></span></p><p>
      <span>10 hundreds =; 1 ten;</span></p><p><span></span></p><p><span></span></p><p><span>10 ones =; 1 hundred;</span>
      </p><p><span>3 ones=;; </span></p><p><span>[#{tag_name}: #{end_value}]</span></p>
    HTML
  end
  let(:columns_count) { '2' }
  let(:end_value) { DocTemplate::Tags::ColumnsTag::END_VALUE }
  let(:tag) { described_class.new }
  let(:tag_name) { DocTemplate::Tags::ColumnsTag::TAG_NAME }

  let(:node) do
    html = Nokogiri::HTML original_content
    html.at_xpath('*//p')
  end

  subject { tag.parse(node, value: columns_count).render.to_html }

  it 'removes original node' do
    expect(subject).to_not include("[#{tag_name}: #{columns_count}]")
  end

  it 'renders corresponding template' do
    expect(ERB).to receive_message_chain(:new, :result).and_return('')
    subject
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

  context 'when there are nested tag' do
    let(:original_content) do
      <<-HTML
        <p><span>[#{tag_name}: #{columns_count}]</span></p><p><span>10 tens =; 1 thousand; </span></p><p><span></span></p><p><span></span></p><p>
        <span>[RI.2.1] 10 hundreds =; 1 ten;</span></p><p><span></span></p><p><span></span></p><p><span>10 ones =; 1 hundred;</span>
        </p><p><span>3 ones=;; </span></p><p><span>[#{tag_name}: #{end_value}]</span></p>
      HTML
    end

    it 'renders such tag' do
      expect_any_instance_of(described_class).to receive(:parse_nested).and_call_original
      subject
    end
  end
end
