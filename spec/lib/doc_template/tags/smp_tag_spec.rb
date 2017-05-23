require 'rails_helper'

describe DocTemplate::Tags::SmpTag do
  let(:original_content) do
    <<-HTML
      <p><span>[smp: #{smp_value}]</span></p><p><span>T: Today we&rsquo;re going to practice unit form counting. This </span>
      </p><p><span>time we&rsquo;ll include hundreds! The unit form way to say 324 is 3 hundreds 2 tens 4 ones. (Pull the cards apart to show the 300, 20, and 4.) </span>
      </p><p><span></span></p><p><span></span></p><a id="t.db6a1f0d703e0579c496bd3f0aa8cbf23a66d6d6"></a><a id="t.5"></a>
      <p><span>T: Try this number. (Show 398. Signal.) </span></p><p><span>S: 3 hundreds 9 tens 8 ones. </span></p><p><span>T: (Pull cards apart.) That&rsquo;s right! </span>
      </p><p><span>T: Let&rsquo;s count on from 398 the unit form way. (Display 399&ndash;405 with Hide Zero cards as students count.) </span>
      </p><p><span>S: 3 hundreds 9 tens 9 ones, 4 hundreds, 4 hundreds 1 one, 4 hundreds 2 ones, 4 hundreds 3 ones, 4 hundreds 4 ones, 4 hundreds 5 ones.</span>
      </p><p><span>[smp: end]</span></p>
    HTML
  end
  let(:smp_value) { 'MP.6; MP.12' }
  let(:start_mark) { %( <div smp-start smp-value="#{smp_value}"></div> ) }
  let(:tag) { described_class.new }

  context 'when start tag is found' do
    let(:node) do
      html = Nokogiri::HTML original_content
      html.at_xpath('*//p')
    end

    subject { tag.parse(node, value: smp_value).render.to_html }

    it 'removes original node' do
      expect(subject).to_not include("[smp: #{smp_value}]")
    end

    it 'places start mark' do
      expect(subject).to include(start_mark)
    end
  end

  context 'when end node is found' do
    let(:node) do
      html = Nokogiri::HTML original_content
      html.at_xpath('*//p').replace(start_mark)
      html.at_xpath('*//span[contains(., "[smp: end]")]').parent
    end

    subject { tag.parse(node, value: 'end').render.to_html }

    it 'removes start mark' do
      expect(subject).to_not include(start_mark)
    end

    it 'renders corresponding template' do
      expect(ERB).to receive_message_chain(:new, :result).and_return('')
      subject
    end
  end
end
