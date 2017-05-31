require 'rails_helper'
require 'doc_template.rb'

describe DocTemplate do
  let(:html_document) do
    temp = Tempfile.new('afile.html')
    temp.write "<html><head></head><body>#{content}</body></html>"
    temp.rewind
    temp
  end

  describe 'agenda table parsing' do
    let(:group1) { 'opening' }
    let(:group2) { 'closing' }
    let(:section1) { 'example with % $*,chars' }
    let(:content) do
      <<-TABLE
      <table><tbody>
      <tr>
        <td colspan="1" rowspan="1"><p><span>[agenda]</span></p></td>
        <td colspan="1" rowspan="1"><p><span>[metacog]</span></p></td>
      </tr>
      <tr>
        <td colspan="1" rowspan="1">
          <p><span>[Group:</span><span>&nbsp;#{group1}</span><span>]</span></p>
          <a id="t.260b97c46fbd646db79b6e0c1dc5a8c9fcfbc610"></a><a id="t.3"></a>
          <table><tbody> <tr>
            <td colspan="1" rowspan="1"><p><span>metadata</span></p></td>
            <td colspan="1" rowspan="1"><p><span></span></p></td>
            </tr> </tbody></table>
        </td>
        <td colspan="1" rowspan="1">
          <p><span>[Group: #{group1}] </span></p>
        </td>
      </tr>
      <tr>
        <td colspan="1" rowspan="1">
          <p><span>[Section:</span><span>&nbsp;#{section1}</span><span>]</span></p>
          <a id="t.260b97c46fbd646db79b6e0c1dc5a8c9fcfbc610"></a><a id="t.3"></a>
          <table><tbody> <tr>
            <td colspan="1" rowspan="1"><p><span>metadata</span></p></td>
            <td colspan="1" rowspan="1"><p><span></span></p></td>
            </tr> </tbody></table>
        </td>
        <td colspan="1" rowspan="1">
          <p><span>[Section: #{section1}] </span></p>
        </td>
      </tr>
      <tr>
        <td colspan="1" rowspan="1">
          <p><span>[Group:</span><span>&nbsp;#{group2}</span><span>]</span></p>
          <a id="t.260b97c46fbd646db79b6e0c1dc5a8c9fcfbc610"></a><a id="t.3"></a>
          <table><tbody><tr>
            <td colspan="1" rowspan="1"><p><span>metadata</span></p></td>
            <td colspan="1" rowspan="1"><p><span></span></p></td>
            </tr></tbody></table>
          <p><span></span></p>
        </td>
        <td colspan="1" rowspan="1">
          <p><span>[Group: #{group2}] </span></p>
        </td>
      </tr>
      </tbody></table>
      TABLE
    end
    subject { DocTemplate::Template.parse(html_document) }

    it 'returns the agenda structure' do
      expect(subject.agenda.count).to eq 2
      expect(subject.agenda.first[:id]).to eq group1.parameterize
      expect(subject.agenda.first[:children].count).to eq 1
      expect(subject.agenda.first[:children].first[:id]).to eq section1.parameterize
      expect(subject.agenda.last[:id]).to eq group2.parameterize
      expect(subject.agenda.last[:children].count).to eq 0
    end
  end

  describe 'metadata parsing' do
    let(:content) do
      '<p>sample text</p>' \
      + '<table class="c12"><tbody><tr class="c6"><td class="c46" colspan="2" rowspan="1"><p class="c61"><span class="c8 c14">document-metadata</span></p></td></tr><tr class="c6"><td class="c32 c18" colspan="1" rowspan="1"><p class="c61"><span class="c8 c14 c18">subject</span></p></td><td class="c54 c18" colspan="1" rowspan="1"><p class="c61"><span class="c8 c14 c18">ela</span></p></td></tr><tr class="c6"><td class="c32 c18" colspan="1" rowspan="1"><p class="c61"><span class="c8 c14 c18">grade</span></p></td><td class="c18 c54" colspan="1" rowspan="1"><p class="c61"><span class="c24">2</span></p></td></tr><tr class="c6"><td class="c18 c32" colspan="1" rowspan="1"><p class="c61"><span class="c8 c14 c18">module</span></p></td><td class="c54 c18" colspan="1" rowspan="1"><p class="c61"><span class="c24">listening and learning strand</span></p></td></tr><tr class="c6"><td class="c32 c18" colspan="1" rowspan="1"><p class="c61"><span class="c8 c14 c18">unit</span></p></td><td class="c54 c18" colspan="1" rowspan="1"><p class="c61"><span class="c8 c14 c18">1</span></p></td></tr><tr class="c6"><td class="c32 c18" colspan="1" rowspan="1"><p class="c61"><span class="c8 c14 c18">lesson</span></p></td><td class="c54 c18" colspan="1" rowspan="1"><p class="c61"><span class="c24">1</span></p></td></tr><tr class="c6"><td class="c32 c18" colspan="1" rowspan="1"><p class="c61"><span class="c24 c18">standard</span></p></td><td class="c54 c18" colspan="1" rowspan="1"><p class="c11"><span class="c8 c14 c18"></span></p></td></tr><tr class="c6"><td class="c25" colspan="1" rowspan="1"><p class="c7"><span class="c24">title</span></p></td><td class="c16" colspan="1" rowspan="1"><p class="c7"><span class="c24">The Fisherman and His Wife</span></p></td></tr><tr class="c6"><td class="c25" colspan="1" rowspan="1"><p class="c7"><span class="c24">teaser</span></p></td><td class="c16" colspan="1" rowspan="1"><p class="c7 c21"><span class="c8 c14"></span></p></td></tr><tr class="c6"><td class="c25" colspan="1" rowspan="1"><p class="c7"><span class="c24">description</span></p></td><td class="c16" colspan="1" rowspan="1"><p class="c7"><span class="c24">Through interactive read-aloud and discussion of </span><span class="c24 c20">The Fisherman and His Wife</span><span class="c24">, students will review characteristics of fairy tales and review beginning, middle, and end of story to support their retelling of the story.</span></p></td></tr><tr class="c6"><td class="c25" colspan="1" rowspan="1"><p class="c7"><span class="c24">text-title</span></p></td><td class="c16" colspan="1" rowspan="1"><p class="c7"><span class="c24">The Fisherman and His Wife</span></p></td></tr><tr class="c6"><td class="c25" colspan="1" rowspan="1"><p class="c7"><span class="c24">text-author</span></p></td><td class="c16" colspan="1" rowspan="1"><p class="c7"><span class="c24">Retelling from Brothers Grimm</span></p></td></tr><tr class="c6"><td class="c25" colspan="1" rowspan="1"><p class="c7"><span class="c24">genre</span></p></td><td class="c16" colspan="1" rowspan="1"><p class="c7"><span class="c24">Fairy Tale</span></p></td></tr><tr class="c6"><td class="c25" colspan="1" rowspan="1"><p class="c7"><span class="c24">text-type</span></p></td><td class="c16" colspan="1" rowspan="1"><p class="c7"><span class="c24">Fiction</span></p></td></tr><tr class="c6"><td class="c25" colspan="1" rowspan="1"><p class="c7"><span class="c8 c14">writing-type</span></p></td><td class="c16" colspan="1" rowspan="1"><p class="c7"><span class="c8 c14">Narrative</span></p></td></tr><tr class="c6"><td class="c25" colspan="1" rowspan="1"><p class="c7"><span class="c8 c14">group-size</span></p></td><td class="c16" colspan="1" rowspan="1"><p class="c7 c21"><span class="c8 c14"></span></p></td></tr><tr class="c6"><td class="c25" colspan="1" rowspan="1"><p class="c7"><span class="c8 c14">ccss-strand</span></p></td><td class="c16" colspan="1" rowspan="1"><p class="c7 c21"><span class="c8 c14"></span></p></td></tr><tr class="c6"><td class="c25" colspan="1" rowspan="1"><p class="c7"><span class="c8 c14">ccss-sub-strand</span></p></td><td class="c16" colspan="1" rowspan="1"><p class="c7 c21"><span class="c8 c14"></span></p></td></tr><tr class="c6"><td class="c25" colspan="1" rowspan="1"><p class="c7"><span class="c8 c14">cc-attribution</span></p></td><td class="c16" colspan="1" rowspan="1"><p class="c7"><span class="c8 c14">This work is based on an original work of the Core</span></p><p class="c7"><span class="c8 c14">Knowledge® Foundation made available through</span></p><p class="c7"><span class="c8 c14">licensing under a Creative Commons Attribution-</span></p><p class="c7"><span class="c8 c14">NonCommercial-ShareAlike 3.0 Unported License. This</span></p><p class="c7"><span class="c8 c14">does not in any way imply that the Core Knowledge</span></p><p class="c7"><span class="c8 c14">Foundation endorses this work.</span></p></td></tr></tbody></table>' \
      + '<p>another sample text</p>'
    end
    subject { DocTemplate::Template.parse(html_document) }

    it 'returns the values hash' do
      expect(subject.metadata.keys).to include('subject')
    end
  end

  describe 'document rendering' do
    let(:content) { '<p>sample 1</p>' }
    subject { DocTemplate::Template.parse(html_document) }

    it 'renders an html document' do
      expect(subject.render).to include(content)
    end
  end

  describe 'tag rendering' do
    describe 'capturing tags on multiple nodes' do
      let(:tag) { '<span>[ATAG: </span><span>ending]</span>' }
      let(:content) { "<p><span>stay</span>#{tag}</p><p>info to slice</p>" }
      subject { DocTemplate::Template.parse(html_document) }

      it 'renders the default' do
        output = subject.render
        expect(output).to_not include(tag)
      end
    end

    describe 'nested tags' do
      let(:tag) { '<span>[ATAG: </span><span>ending]</span>' }
      let(:tag2) { '<span>[ATAG2: </span><span>an_ending]</span>' }
      let(:content) { "<p><span>stay</span>#{tag}#{tag2}</p><p>info to slice</p>" }
      subject { DocTemplate::Template.parse(html_document) }
      it 'renders the default' do
        output = subject.render
        expect(output).not_to include(tag)
        expect(output).not_to include(tag2)
      end
    end

    describe 'default tag' do
      let(:tag) { '<p><span>[ATAG some info]</span></p>' }
      let(:content) { "#{tag}<p>info to slice</p>" }
      subject { DocTemplate::Template.parse(html_document) }
      it 'renders the default' do
        expect(subject.render).to include content.sub(tag, '')
      end
    end

    # TODO: refactor to the actual state
    xdescribe 'tokenization' do
      let(:tag) { '<p><span>[ATAG some info]</span>[ANOTHERTAG blbl]</p>' }
      let(:content) { "#{tag}<p>info to slice</p>" }
      subject { DocTemplate::Template.parse(html_document) }

      it 'replaces the tag node with a placeholder' do
        expect(subject.render).to match(/{{default_tag_\w+}}/)
      end

      it 'replaces nested tags with placeholders' do
        skip
        expect(subject.render).to match(/(.?default_tag_\w+){2}/)
      end
    end

    # TODO: refactor to the actual state
    xdescribe '#parts' do
      let(:tag) { '<p><span>[ATAG some info]</span>[ANOTHERTAG blbl]</p>' }
      let(:content) { "#{tag}<p>info to slice</p>" }
      subject { DocTemplate::Template.parse(html_document) }

      it 'returns the placeholder and the tag content' do
        expect(subject.parts.first[:placeholder]).to include 'default_tag_'
        expect(subject.parts.first[:content]).to eq tag
        expect(subject.parts.first[:part_type]).to eq 'ATAG'
      end
    end
  end
end
