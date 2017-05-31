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
end
