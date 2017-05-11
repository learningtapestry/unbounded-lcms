require 'test_helper'

class HtmlSanitizerTest < ActiveSupport::TestCase
  def html
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

  def test_remove_gdocs_suggestion
    sanitized = HtmlSanitizer.sanitize(html)
    assert sanitized.include?('cmnt_ref') == false
  end

  def charts_html
    <<-html
    <p>
      <span>Using the floor tiles design shown below, create </span>
      <img src="https://www.google.com/chart?cht=tx&amp;chf=bg,s,FFFFFF00&amp;chco=000000&amp;chl=4">
      <span>&nbsp;different ratios related to the image. &nbsp;Describe the ratio relationship, and write the ratio in the form </span>
      <img src="https://www.google.com/chart?cht=tx&amp;chf=bg,s,FFFFFF00&amp;chco=000000&amp;chl=A%3AB" data-pin-nopin="true"><span>&nbsp;or the form </span><img src="https://www.google.com/chart?cht=tx&amp;chf=bg,s,FFFFFF00&amp;chco=000000&amp;chl=A"><span>&nbsp;to </span><img src="https://www.google.com/chart?cht=tx&amp;chf=bg,s,FFFFFF00&amp;chco=000000&amp;chl=B"><span>. </span>
    </p>
    html
  end

  def test_replace_gdoc_charts
    sanitized = HtmlSanitizer.sanitize(charts_html)
    assert sanitized.include?('www.google') == false
    assert sanitized.include?('chart.googleapis') == true
  end
end
