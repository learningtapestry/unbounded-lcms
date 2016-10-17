require 'test_helper'

class PageNotFoundTest < ActionDispatch::IntegrationTest
  def test_404_page
    resource = Resource.create(title: '404')
    resource.resource_slugs.create!(value: '404')

    assert_not_found '/404'
  end

  def test_content_guide_page
    assert_not_found '/content_guides/wtf'
  end

  def test_media_page
    assert_not_found '/media/wtf'
  end

  def test_resource_page
    assert_not_found '/wtf'
  end

  private
    def assert_not_found(path)
      visit path
      assert_equal 404, page.status_code
      assert_equal 'UnboundEd - Page Not Found', page.title
      assert page.has_link?('Search page', href: '/search')
    end
end
