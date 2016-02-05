require 'test_helper'

class ResourceUrlsTest < ActionDispatch::IntegrationTest
  def test_download_url_pattern_1
    resource = resources(:unbounded_rewrite_urls)
    visit "resources/#{(resource.id)}"
    assert find_link('Download URL #1')['href'].start_with?('http://k12-content.s3-website-us-east-1.amazonaws.com/')
  end

  def test_download_url_pattern_2
    resource = resources(:unbounded_rewrite_urls)
    visit "resources/#{(resource.id)}"
    assert find_link('Download URL #2')['href'].start_with?('http://k12-content.s3-website-us-east-1.amazonaws.com/')
  end

  def test_download_url_no_slash
    resource = resources(:unbounded_rewrite_urls)
    visit "resources/#{(resource.id)}"
    assert find_link('Download URL No Slash')['href'].start_with?('http://k12-content.s3-website-us-east-1.amazonaws.com/')
  end

  def test_resource_url_canonical
    resource = resources(:unbounded_rewrite_urls)
    expected_resource = resources(:unbounded_engageny_source)

    visit "resources/#{(resource.id)}"
    expected_link = "resources/#{(expected_resource.id)}"
    assert find_link('Resource URL Canonical')['href'].end_with?(expected_link)
  end

  def test_resource_url_no_slash
    resource = resources(:unbounded_rewrite_urls)
    expected_resource = resources(:unbounded_engageny_source)

    visit "resources/#{(resource.id)}"
    expected_link = "resources/#{(expected_resource.id)}"
    assert find_link('Resource URL No Slash')['href'].end_with?(expected_link)
  end
end
