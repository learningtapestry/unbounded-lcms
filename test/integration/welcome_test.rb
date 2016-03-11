require 'test_helper'

class WelcomeTestCase < ActionDispatch::IntegrationTest
  def test_show
    visit '/'
    assert has_css?('.c-hp-ela')
  end
end
