require 'test_helper'

class HtmlSanitizerTest < ActiveSupport::TestCase
  def html
    <<-TABLE
    <tbody>
      <tr>
        <td colspan=\"2\" rowspan=\"1\">
          <p>
            <span>d</span><sup><a href=\"#cmnt1\" id=\"cmnt_ref1\">[a]</a></sup><sup><a href=\"#cmnt2\" id=\"cmnt_ref2\">[b]</a></sup><span>ocument-metadata</span><sup><a href=\"#cmnt3\" id=\"cmnt_ref3\">[c]</a></sup>
          </p>
        </td>
      </tr>
    </tbody>
    TABLE
  end

  def test_remove_gdocs_suggestion
    sanitized = HtmlSanitizer.sanitize(html)
    assert sanitized.include?('cmnt_ref') == false
  end
end
