require 'test_helper'

class LobjectCollectionTypesTestCase < IntegrationTestCase
  def setup
    super
    @admin = users(:admin)
    @collection_type = lobject_collection_types(:curriculum_map)
    login_as @admin
  end

  def test_new_collection_type
    visit unbounded_admin_path
    click_link 'Collection Types'
    assert_equal current_path, unbounded_admin_collection_types_path
    click_link 'Add Collection Type'
    assert_equal current_path, new_unbounded_admin_collection_type_path
    click_button 'Save'
    assert_equal find('.form-group.content_models_lobject_collection_type_name.has-error .help-block').text, "can't be blank"

    fill_in 'Name', with: '  curriculum MAP   '
    click_button 'Save'
    assert_equal find('.form-group.content_models_lobject_collection_type_name.has-error .help-block').text, 'has already been taken'

    name = Faker::Lorem.sentence
    fill_in 'Name', with: name
    click_button 'Save'
    collection_type = Content::Models::LobjectCollectionType.reorder(:id).last
    assert_equal collection_type.name, name
    assert_equal current_path, unbounded_admin_collection_type_path(collection_type.id)
    assert_equal find('.alert.alert-success').text, '× Collection Type created successfully.'
  end

  def test_show_collection_type
    visit unbounded_admin_path
    click_link 'Collection Types'
    within "#collection_type_#{@collection_type.id}" do
      click_link @collection_type.name
    end
    assert_equal current_path, unbounded_admin_collection_type_path(@collection_type.id)
    assert_equal find('h2').text, @collection_type.name

    click_link 'Edit'
    assert_equal current_path, edit_unbounded_admin_collection_type_path(@collection_type.id)
  end

  def test_edit_collection_type
    visit unbounded_admin_path
    click_link 'Collection Types'
    within "#collection_type_#{@collection_type.id}" do
      click_link 'Edit'
    end
    assert_equal current_path, edit_unbounded_admin_collection_type_path(@collection_type.id)

    name = Faker::Lorem.sentence
    fill_in 'Name', with: name
    click_button 'Save'
    @collection_type.reload
    assert_equal @collection_type.name, name
    assert_equal current_path, unbounded_admin_collection_type_path(@collection_type.id)
    assert_equal find('.alert.alert-success').text, '× Collection Type updated successfully.'
  end

  def test_delete_collection_type_from_index_page
    collection_type = lobject_collection_types(:nti)
    visit '/unbounded/admin/collection_types'
    within "#collection_type_#{collection_type.id}" do
      click_button 'Delete'
    end
    assert_nil LobjectCollectionType.find_by_id(collection_type.id)
    assert_equal current_path, '/unbounded/admin/collection_types'
    assert_equal find('.alert.alert-success').text, "× Collection Type deleted successfully."
  end

  def test_delete_collection_type_from_show_page
    collection_type = lobject_collection_types(:curriculum_map)
    visit '/unbounded/admin/collection_types'
    click_link collection_type.name
    assert_equal current_path, "/unbounded/admin/collection_types/#{collection_type.id}"
    click_button 'Delete'
    assert_nil LobjectCollectionType.find_by_id(collection_type.id)
    assert_equal current_path, '/unbounded/admin/collection_types'
    assert_equal find('.alert.alert-success').text, "× Collection Type deleted successfully."
  end
end
