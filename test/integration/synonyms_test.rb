require 'test_helper'

class SynonymsTestCase < IntegrationTestCase
  def setup
    super
    admin = users(:admin)
    login_as admin
  end

  def teardown
    Lobject.__elasticsearch__.create_index!(force: true)
    super
  end

  def test_edit_synonyms
    visit '/lt/admin'
    click_link 'Edit synonyms'
    assert_equal current_path, '/lt/admin/synonyms'

    fill_in 'synonyms', with: "test,doesitwork\r\nyep,itworks"
    click_button 'Save'

    assert_equal ['test,doesitwork', 'yep,itworks'], Lobject.get_index_synonyms
  end
end
