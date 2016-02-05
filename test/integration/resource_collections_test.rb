require 'test_helper'

class ResourceCollectionsTestCase < ActionDispatch::IntegrationTest
  def setup
    super

    @admin           = users(:admin)
    @collection_type = resource_collection_types(:curriculum_map)
    @resource         = resources(:unbounded)

    login_as @admin
  end

  def test_new_resource_collection
    visit '/admin/collections'
    click_link 'Add Learning Objects Collection'
    click_button 'Save'
    assert_equal find('.form-group.resource_collection_resource.has-error .help-block').text, "can't be blank"

    select @collection_type.name, from: 'Collection Type'
    select @resource.title,        from: 'Root Learning Object'
    click_button 'Save'
    collection = ResourceCollection.last
    assert_equal collection.resource_collection_type, @collection_type
    assert_equal collection.resource, @resource
    assert_equal current_path, "/admin/collections/#{collection.id}/edit"
    assert_equal find('.alert.alert-success').text, '× Learning Objects Collection created successfully.'
  end

  def test_edit_collection
    collection = resource_collections(:easol)

    visit '/admin'
    click_link 'Collections'
    within "#collection_#{collection.id}" do
      click_link 'Edit'
    end
    assert_equal current_path, "/admin/collections/#{collection.id}/edit"
    select @collection_type.name, from: 'Collection Type'
    click_button 'Save'
    collection.reload
    assert_equal collection.resource_collection_type, @collection_type
    assert_equal current_path, "/admin/collections/#{collection.id}"
  end

  def test_delete_collection_from_index_page
    collection = resource_collections(:easol)
    visit '/admin/collections'
    within "#collection_#{collection.id}" do
      click_button 'Delete'
    end
    assert_nil ResourceCollection.find_by_id(collection.id)
    assert_equal current_path, '/admin/collections'
    assert_equal find('.alert.alert-success').text, "× Learning Objects Collection ##{collection.id} was deleted successfully."
  end

  def test_delete_collection_from_show_page
    collection = resource_collections(:unbounded)
    visit '/admin/collections'
    click_link collection.resource.title
    assert_equal current_path, "/admin/collections/#{collection.id}"
    click_button 'Delete'
    assert_nil ResourceCollection.find_by_id(collection.id)
    assert_equal current_path, '/admin/collections'
    assert_equal find('.alert.alert-success').text, "× Learning Objects Collection ##{collection.id} was deleted successfully."
  end
end
