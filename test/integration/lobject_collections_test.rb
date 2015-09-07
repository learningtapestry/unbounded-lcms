require 'test_helper'

class LobjectCollectionsTestCase < IntegrationTestCase
  def setup
    super

    @admin   = users(:admin)
    @lobject = lobjects(:unbounded)

    login_as @admin
  end

  def test_new_lobject_collection
    visit '/unbounded/admin/collections'
    click_link 'Add Learning Objects Collection'
    click_button 'Save'
    assert_equal find('.form-group.content_models_lobject_collection_lobject.has-error .help-block').text, "can't be blank"

    select @lobject.title, from: 'Root Learning Object'
    click_button 'Save'
    collection = LobjectCollection.last
    assert_equal collection.lobject, @lobject
    assert_equal current_path, "/unbounded/admin/collections/#{collection.id}"
    assert_equal find('.alert.alert-success').text, '× Learning Objects Collection created successfully.'
  end
end
