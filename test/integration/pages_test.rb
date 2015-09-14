require 'test_helper'

class PagesTestCase < IntegrationTestCase
  def test_show_page
    page = Page.create!(body: Faker::Lorem.sentence(100), title: Faker::Lorem.sentence(10))
    visit "/unbounded/pages/#{page.id}"
    assert_equal find('h2').text, page.title
    assert_equal find('.col-sm-12').text, page.body
  end
end
