require 'test_helper'

module Unbounded
  class LobjectUrlsTest < IntegrationTestCase
    def test_download_url_pattern_1
      lobject = lobjects(:unbounded_rewrite_urls)
      visit "resources/#{(lobject.id)}"
      assert find_link('Download URL #1')['href'].start_with?('http://k12-content.s3-website-us-east-1.amazonaws.com/')
    end

    def test_download_url_pattern_2
      lobject = lobjects(:unbounded_rewrite_urls)
      visit "resources/#{(lobject.id)}"
      assert find_link('Download URL #2')['href'].start_with?('http://k12-content.s3-website-us-east-1.amazonaws.com/')
    end

    def test_lobject_url_canonical
      lobject = lobjects(:unbounded_rewrite_urls)
      expected_lobject = lobjects(:unbounded_engageny_source)

      visit "resources/#{(lobject.id)}"
      expected_link = "resources/#{(expected_lobject.id)}"
      assert find_link('Lobject URL Canonical')['href'].end_with?(expected_link)
    end

    def test_lobject_url_non_canonical
      lobject = lobjects(:unbounded_rewrite_urls)
      expected_lobject = lobjects(:unbounded_with_canonical_url)
      
      visit "resources/#{(lobject.id)}"
      expected_link = "resources/#{(expected_lobject.id)}"
      assert find_link('Lobject URL Non-canonical')['href'].end_with?(expected_link)
    end
  end
end
