require 'rails_helper'

describe HtmlSanitizer do
  let(:html) do
    <<-table
    <tbody>
    <tr>
    <td colspan=\"2\" rowspan=\"1\">
    <p>
    <span>d</span><sup><a href=\"#cmnt1\" id=\"cmnt_ref1\">[a]</a></sup><sup><a href=\"#cmnt2\" id=\"cmnt_ref2\">[b]</a></sup><span>ocument-metadata</span><sup><a href=\"#cmnt3\" id=\"cmnt_ref3\">[c]</a></sup>
    </p>
    </td>
    </tr>
    </tbody>
    table
  end

  let(:charts_html) do
    <<-html
    <p>
      <span>Using the floor tiles design shown below, create </span>
      <img src="https://www.google.com/chart?cht=tx&amp;chf=bg,s,FFFFFF00&amp;chco=000000&amp;chl=4">
      <span>&nbsp;different ratios related to the image. &nbsp;Describe the ratio relationship, and write the ratio in the form </span>
      <img src="https://www.google.com/chart?cht=tx&amp;chf=bg,s,FFFFFF00&amp;chco=000000&amp;chl=A%3AB" data-pin-nopin="true"><span>&nbsp;or the form </span><img src="https://www.google.com/chart?cht=tx&amp;chf=bg,s,FFFFFF00&amp;chco=000000&amp;chl=A"><span>&nbsp;to </span><img src="https://www.google.com/chart?cht=tx&amp;chf=bg,s,FFFFFF00&amp;chco=000000&amp;chl=B"><span>. </span>
    </p>
    html
  end

  it 'removes gdocs suggestions' do
    sanitized = described_class.sanitize(html)
    expect(sanitized).to_not include('cmnt_ref')
  end

  it 'replaces gdocs charts' do
    sanitized = described_class.sanitize(charts_html)
    expect(sanitized).to_not include('www.google')
    expect(sanitized).to include('chart.googleapis')
  end

  describe '.clean_content' do
    subject { HtmlSanitizer.clean_content(html, opts) }

    context 'not gdoc' do
      let(:opts) { {} }
      let(:html) { '<p></p>' }

      it 'skips it' do
        expect(subject).to eq(html)
      end
    end

    context 'gdoc' do
      let(:opts) { 'gdoc' }
      let(:nested_html) do
        <<-html
          <p></p>
          <p><span> </span></p>
          <h4><table/></table></h4>
        html
      end
      let(:p_html) do
        <<-html
          <p>TEXT</p>
          <p><span> </span></p>
          <h4><table/></table></h4>
        html
      end

      context 'with simple html' do
        let(:html) do
          <<-html
            <p>NOT EMPTY</p>
            <h4></h4>
            <table/></table>
          html
        end

        it 'combines empty elements into 1' do
          expect(subject).to eq('<p>NOT EMPTY</p>')
        end
      end

      context 'with nested html' do
        let(:html) { nested_html }

        it 'collapse elements' do
          expect(subject).to be_empty
        end
      end

      context 'with nested html with p' do
        let(:html) { p_html }

        it 'combines empty elements into 1' do
          expect(subject).to eq('<p>TEXT</p>')
        end
      end

      context 'with several html blocks' do
        let(:html) do
          <<-html
            <div>
              #{p_html}
            </div>
            <h4>H4</h4>
            <div>
              #{nested_html}
            </div>
          html
        end

        it 'keeps non empty elements' do
          expect(subject.gsub(/\s*/, '')).to eq('<div><p>TEXT</p></div><h4>H4</h4><div></div>')
        end
      end

      context 'with do-not-strip elements first' do
        let(:html) do
          <<-html
            <table>
              <td>NOT EMPTY</td>
            </table>
            <p class="do-not-strip u-gdoc-empty-p"></p>
            <p><span> </span></p>
          html
        end

        it 'keeps do-not-strip element' do
          expect(subject.gsub(/\s+/, ' ')).to eq('<table> <td>NOT EMPTY</td> </table> <p class="do-not-strip u-gdoc-empty-p"></p>')
        end
      end

      context 'with p in ul section' do
        let(:html) do
          <<-html
            <p><span>Students will:</span></p>
            <ul>
              <li><p><span><span>Identify the characteristics of fairy tales using literary language and explain the characteristics as they apply to the fairy tale </span></p></li>
              <li><p><span>Prior to listening to </span></p></li>
            </ul>
            <p></p>
            <p>NOT EMPTY</p>
          html
        end

        it 'keeps empty p after ul' do
          expect(subject.scan('<p>').size).to eq 5
        end
      end
    end
  end
end
