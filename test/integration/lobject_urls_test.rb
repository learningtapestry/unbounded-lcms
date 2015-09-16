require 'test_helper'

class LobjectUrlsTest < IntegrationTestCase
  def test_url_pattern_1
    lobject = lobjects(:unbounded_rewrite_urls)
    visit "/unbounded/show/#{lobject.id}"
    assert find_link('URL Pattern #1')['href'].start_with?('http://k12-content.s3-website-us-east-1.amazonaws.com/')
  end

  def test_url_pattern_2
    lobject = lobjects(:unbounded_rewrite_urls)
    visit "/unbounded/show/#{lobject.id}"
    assert find_link('URL Pattern #2')['href'].start_with?('http://k12-content.s3-website-us-east-1.amazonaws.com/')
  end
end
